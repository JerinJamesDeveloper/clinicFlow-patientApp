/// API Interceptors
/// 
/// Dio interceptors for handling authentication, logging, and errors.
/// Automatically adds auth tokens and handles token refresh.
library;

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/storage_keys.dart';
import '../storage/local_storage.dart';
import '../errors/exceptions.dart';

/// Interceptor for adding authentication headers
class AuthInterceptor extends Interceptor {
  final LocalStorage _storage;
  final Logger _logger = Logger();

  AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async{
    // Get access token from storage
    final accessToken = await  _storage.getString(StorageKeys.accessToken);

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.d(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _logger.e(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );

    // Handle 401 Unauthorized - token might be expired
    if (err.response?.statusCode == 401) {
      // Clear stored tokens
      _storage.remove(StorageKeys.accessToken);
      _storage.remove(StorageKeys.refreshToken);
      _storage.remove(StorageKeys.isLoggedIn);
    }

    handler.next(err);
  }
}

/// Interceptor for logging requests and responses
class LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
    ),
  );

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    _logger.i('''
┌──────────────────────────────────────────────────────────────────────────────
│ REQUEST
│ ${options.method} ${options.uri}
│ Headers: ${options.headers}
│ Data: ${options.data}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    _logger.i('''
┌──────────────────────────────────────────────────────────────────────────────
│ RESPONSE
│ ${response.statusCode} ${response.requestOptions.uri}
│ Data: ${response.data}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    _logger.e('''
┌──────────────────────────────────────────────────────────────────────────────
│ ERROR
│ ${err.response?.statusCode} ${err.requestOptions.uri}
│ Message: ${err.message}
│ Response: ${err.response?.data}
└──────────────────────────────────────────────────────────────────────────────
''');
    handler.next(err);
  }
}

/// Interceptor for handling and transforming errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    final exception = _handleError(err);
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: exception,
        response: err.response,
        type: err.type,
      ),
    );
  }

  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.badCertificate:
        return const ServerException(
          message: 'Invalid certificate',
          code: 'BAD_CERTIFICATE',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const CancelledException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.unknown:
        if (error.error != null && error.error.toString().contains('SocketException')) {
          return const NetworkException();
        }
        return UnexpectedException(
          message: error.message ?? 'An unexpected error occurred',
        );
    }
  }

  AppException _handleResponseError(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    
    String message = 'An error occurred';
    String? code;
    
    if (data is Map<String, dynamic>) {
      message = data['message'] as String? ?? message;
      code = data['code'] as String?;
    }

    switch (statusCode) {
      case 400:
        if (data is Map<String, dynamic> && data['errors'] != null) {
          return ValidationException(
            message: message,
            errors: _parseValidationErrors(data['errors']),
          );
        }
        return ServerException(message: message, statusCode: statusCode, code: code);

      case 401:
        return UnauthorizedException(message: message, code: code);

      case 403:
        return ForbiddenException(message: message, code: code);

      case 404:
        return NotFoundException(message: message, code: code);

      case 422:
        return ValidationException(
          message: message,
          errors: data is Map<String, dynamic> 
              ? _parseValidationErrors(data['errors']) 
              : null,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
          code: code,
        );

      default:
        return ServerException(
          message: message,
          statusCode: statusCode,
          code: code,
        );
    }
  }

  Map<String, List<String>>? _parseValidationErrors(dynamic errors) {
    if (errors == null) return null;
    
    if (errors is Map<String, dynamic>) {
      return errors.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.map((e) => e.toString()).toList());
        }
        return MapEntry(key, [value.toString()]);
      });
    }
    
    return null;
  }
}

/// Interceptor for retry logic
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on network errors or timeouts
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < maxRetries) {
        await Future.delayed(retryDelay * (retryCount + 1));

        final options = err.requestOptions;
        options.extra['retryCount'] = retryCount + 1;

        try {
          final response = await _dio.fetch(options);
          handler.resolve(response);
          return;
        } catch (e) {
          // Continue with the error
        }
      }
    }

    handler.next(err);
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.type == DioExceptionType.unknown &&
            err.error.toString().contains('SocketException'));
  }
}