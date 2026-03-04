/// Custom Exceptions
/// 
/// Exception classes for handling different types of errors.
/// These are thrown by data sources and caught in repositories.
library;

/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException({
    required this.message,
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Exception thrown when there's a server/API error
class ServerException extends AppException {
  final int? statusCode;

  const ServerException({
    required super.message,
    super.code,
    super.details,
    this.statusCode,
  });

  @override
  String toString() => 'ServerException: $message (status: $statusCode, code: $code)';
}

/// Exception thrown when user is not authorized
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.code = 'UNAUTHORIZED',
    super.details,
  });
}

/// Exception thrown when access is forbidden
class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'Access forbidden',
    super.code = 'FORBIDDEN',
    super.details,
  });
}

/// Exception thrown when resource is not found
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.code = 'NOT_FOUND',
    super.details,
  });
}

/// Exception thrown when there's a network connectivity issue
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
    super.details,
  });
}
 
/// Exception thrown when a request is cancelled
class CancelledException extends AppException {
  const CancelledException({
    super.message = 'Request was cancelled',
    super.code = 'CANCELLED',
    super.details,
  });
}

/// Exception thrown for unexpected errors (alias for UnknownException if needed)
class UnexpectedException extends AppException {
  const UnexpectedException({
    super.message = 'An unexpected error occurred',
    super.code = 'UNEXPECTED_ERROR',
    super.details,
  });
}

/// Exception thrown when request times out
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.code = 'TIMEOUT',
    super.details,
  });
}

/// Exception thrown when there's a cache/storage error
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.code = 'CACHE_ERROR',
    super.details,
  });
}

/// Exception thrown for validation errors
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  const ValidationException({
    super.message = 'Validation failed',
    super.code = 'VALIDATION_ERROR',
    super.details,
    this.errors,
  });
}

/// Exception thrown for authentication errors
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code = 'AUTH_ERROR',
    super.details,
  });
} 

/// Exception thrown when token is expired
class TokenExpiredException extends AppException {
  const TokenExpiredException({
    super.message = 'Token has expired',
    super.code = 'TOKEN_EXPIRED',
    super.details,
  });
}

/// Exception thrown when token refresh fails
class RefreshTokenException extends AppException {
  const RefreshTokenException({
    super.message = 'Failed to refresh token',
    super.code = 'REFRESH_TOKEN_ERROR',
    super.details,
  });
}

/// Exception thrown for bad request (400)
class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Bad request',
    super.code = 'BAD_REQUEST',
    super.details,
  });
}

/// Exception thrown when there's a conflict (409)
class ConflictException extends AppException {
  const ConflictException({
    super.message = 'Resource conflict',
    super.code = 'CONFLICT',
    super.details,
  });
}

/// Exception thrown for rate limiting (429)
class RateLimitException extends AppException {
  final Duration? retryAfter;

  const RateLimitException({
    super.message = 'Too many requests',
    super.code = 'RATE_LIMIT',
    super.details,
    this.retryAfter,
  });
}

/// Exception thrown for unknown/unexpected errors
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred',
    super.code = 'UNKNOWN_ERROR',
    super.details,
  });
}

/// Exception thrown for SessionExpiredException errors
class SessionExpiredException extends AppException {
  const SessionExpiredException({
    super.message = 'Storage Error',
    super.code = 'Session_Expired',
    super.details,
  });
}

/// Exception thrown for StorageException errors
class StorageException extends AppException {
  const StorageException({
    super.message = 'session Expired',
    super.code = 'Session_Expired',
    super.details,
  });
}