/// Auth BLoC States
///
/// States representing the current authentication status.
/// UI rebuilds based on state changes.
library;

import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Base class for all auth states
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State while checking authentication status
class AuthLoading extends AuthState {
  /// Optional message to display during loading
  final String? message;

  const AuthLoading({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  /// The authenticated user
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  /// Check if user is admin
  bool get isAdmin => user.isAdmin;

  /// Check if user email is verified
  bool get isEmailVerified => user.isEmailVerified;

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  /// Optional message (e.g., "Session expired")
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when an error occurs
class AuthError extends AuthState {
  /// Error message to display
  final String message;

  /// Field-specific errors (for form validation)
  final Map<String, List<String>>? fieldErrors;

  /// Previous state to restore after clearing error
  final AuthState? previousState;

  const AuthError({
    required this.message,
    this.fieldErrors,
    this.previousState,
  });

  /// Get error for a specific field
  String? getFieldError(String field) {
    return fieldErrors?[field]?.first;
  }

  /// Check if there are field-specific errors
  bool get hasFieldErrors => fieldErrors != null && fieldErrors!.isNotEmpty;

  @override
  List<Object?> get props => [message, fieldErrors, previousState];
}

/// State when password reset email is sent
class AuthPasswordResetSent extends AuthState {
  /// Email address the reset was sent to
  final String email;

  const AuthPasswordResetSent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// State when password is successfully reset
class AuthPasswordResetSuccess extends AuthState {
  const AuthPasswordResetSuccess();
}

/// State when password is successfully changed
class AuthPasswordChangeSuccess extends AuthState {
  const AuthPasswordChangeSuccess();
}

/// State when profile is successfully updated
class AuthProfileUpdateSuccess extends AuthState {
  /// Updated user data
  final UserEntity user;

  const AuthProfileUpdateSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when verification email is resent
class AuthVerificationEmailSent extends AuthState {
  const AuthVerificationEmailSent();
}

/// State during specific operations (login, register, etc.)
class AuthOperationInProgress extends AuthState {
  /// Type of operation in progress
  final AuthOperation operation;

  const AuthOperationInProgress({required this.operation});

  @override
  List<Object?> get props => [operation];
}

/// Types of auth operations
enum AuthOperation {
  login,
  register,
  logout,
  forgotPassword,
  resetPassword,
  changePassword,
  updateProfile,
  resendVerification,
  verifyOtp,
  resendOtp,
}

/// State when OTP is successfully verified
class AuthOtpVerificationSuccess extends AuthState {
  const AuthOtpVerificationSuccess();
}

/// State when OTP is successfully resent
class AuthResendOtpSuccess extends AuthState {
  const AuthResendOtpSuccess();
}
