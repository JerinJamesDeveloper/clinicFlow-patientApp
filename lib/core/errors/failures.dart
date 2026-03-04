/// Failure Classes
/// 
/// Failure classes for handling errors in the domain layer.
/// These are returned from repositories using Either type.
library;

import 'package:equatable/equatable.dart';

/// Base failure class
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, code, statusCode];

  factory ServerFailure.fromStatusCode(int statusCode, [String? message]) {
    switch (statusCode) {
      case 400:
        return ServerFailure(
          message: message ?? 'Bad request',
          code: 'BAD_REQUEST',
          statusCode: statusCode,
        );
      case 401:
        return ServerFailure(
          message: message ?? 'Unauthorized',
          code: 'UNAUTHORIZED',
          statusCode: statusCode,
        );
      case 403:
        return ServerFailure(
          message: message ?? 'Forbidden',
          code: 'FORBIDDEN',
          statusCode: statusCode,
        );
      case 404:
        return ServerFailure(
          message: message ?? 'Not found',
          code: 'NOT_FOUND',
          statusCode: statusCode,
        );
      case 409:
        return ServerFailure(
          message: message ?? 'Conflict',
          code: 'CONFLICT',
          statusCode: statusCode,
        );
      case 422:
        return ServerFailure(
          message: message ?? 'Unprocessable entity',
          code: 'UNPROCESSABLE_ENTITY',
          statusCode: statusCode,
        );
      case 429:
        return ServerFailure(
          message: message ?? 'Too many requests',
          code: 'RATE_LIMIT',
          statusCode: statusCode,
        );
      case 500:
        return ServerFailure(
          message: message ?? 'Internal server error',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );
      case 502:
        return ServerFailure(
          message: message ?? 'Bad gateway',
          code: 'BAD_GATEWAY',
          statusCode: statusCode,
        );
      case 503:
        return ServerFailure(
          message: message ?? 'Service unavailable',
          code: 'SERVICE_UNAVAILABLE',
          statusCode: statusCode,
        );
      default:
        return ServerFailure(
          message: message ?? 'Server error',
          code: 'SERVER_ERROR',
          statusCode: statusCode,
        );
    }
  }
}

/// Failure for network connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Failure for cache/storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage',
    super.code = 'CACHE_ERROR',
  });
}

/// Failure for authentication errors
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code = 'AUTH_ERROR',
  });

  /// Invalid credentials
  factory AuthFailure.invalidCredentials() => const AuthFailure(
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS',
      );

  /// User not found
  factory AuthFailure.userNotFound() => const AuthFailure(
        message: 'User not found',
        code: 'USER_NOT_FOUND',
      );

  /// Email already exists
  factory AuthFailure.emailAlreadyExists() => const AuthFailure(
        message: 'An account with this email already exists',
        code: 'EMAIL_EXISTS',
      );

  /// Token expired
  factory AuthFailure.tokenExpired() => const AuthFailure(
        message: 'Your session has expired. Please login again',
        code: 'TOKEN_EXPIRED', 
      );

  /// Account disabled
  factory AuthFailure.accountDisabled() => const AuthFailure(
        message: 'Your account has been disabled',
        code: 'ACCOUNT_DISABLED',
      );

  /// Email not verified
  factory AuthFailure.emailNotVerified() => const AuthFailure(
        message: 'Please verify your email address',
        code: 'EMAIL_NOT_VERIFIED',
      );
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    this.fieldErrors,
  });

  @override
  List<Object?> get props => [message, code, fieldErrors];

  /// Get error message for a specific field
  String? getFieldError(String field) {
    return fieldErrors?[field]?.first;
  }

  /// Check if a specific field has error
  bool hasFieldError(String field) {
    return fieldErrors?.containsKey(field) ?? false;
  }
}

/// Failure for timeout errors
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Request timed out. Please try again',
    super.code = 'TIMEOUT',
  });
}

class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure({
    super.message = 'Session expired. Please try again',
    super.code = 'SESSION_EXPIRED',
  });
}


/// Failure for permission errors
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission to perform this action',
    super.code = 'PERMISSION_DENIED',
  });
}

/// Failure for not found errors
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'The requested resource was not found',
    super.code = 'NOT_FOUND',
  });
}

/// Failure for unknown/unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again',
    super.code = 'UNKNOWN_ERROR',
  });
}