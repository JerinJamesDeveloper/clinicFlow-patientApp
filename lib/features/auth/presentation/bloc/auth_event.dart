/// Auth BLoC Events
///
/// Events that trigger state changes in the AuthBloc.
/// Each event represents a user action or system event.
library;

import 'package:equatable/equatable.dart';

/// Base class for all auth events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check current authentication status
///
/// Triggered on app start to determine if user is logged in.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to login with email and password
class AuthLoginRequested extends AuthEvent {
  /// User's email address
  final String email;

  /// User's password
  final String password;

  /// Whether to keep user logged in
  final bool rememberMe;

  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Event to register a new user
class AuthRegisterRequested extends AuthEvent {
  /// User's email address
  final String email;

  /// User's password
  final String password;

  /// Password confirmation
  final String confirmPassword;

  /// User's first name
  final String firstName;

  /// User's last name
  final String lastName;

  /// Whether user accepted terms
  final bool acceptedTerms;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    this.acceptedTerms = false,
  });

  @override
  List<Object?> get props => [
    email,
    password,
    confirmPassword,
    firstName,
    lastName,
    acceptedTerms,
  ];
}

/// Event to logout current user
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event to request password reset
class AuthForgotPasswordRequested extends AuthEvent {
  /// Email to send reset link to
  final String email;

  const AuthForgotPasswordRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to reset password with token
class AuthResetPasswordRequested extends AuthEvent {
  /// Reset token from email
  final String token;

  /// New password
  final String newPassword;

  /// Password confirmation
  final String confirmPassword;

  const AuthResetPasswordRequested({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [token, newPassword, confirmPassword];
}

/// Event to change password for logged in user
class AuthChangePasswordRequested extends AuthEvent {
  /// Current password for verification
  final String currentPassword;

  /// New password
  final String newPassword;

  /// Password confirmation
  final String confirmPassword;

  const AuthChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword, confirmPassword];
}

/// Event to update user profile
class AuthUpdateProfileRequested extends AuthEvent {
  /// Updated first name
  final String? firstName;

  /// Updated last name
  final String? lastName;

  /// Updated phone number
  final String? phoneNumber;

  /// Updated avatar URL
  final String? avatarUrl;

  const AuthUpdateProfileRequested({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [firstName, lastName, phoneNumber, avatarUrl];
}

/// Event to resend email verification
class AuthResendVerificationRequested extends AuthEvent {
  const AuthResendVerificationRequested();
}

/// Event to verify OTP
class AuthVerifyOtpRequested extends AuthEvent {
  /// The email the OTP was sent to
  final String email;

  /// The OTP code entered by the user
  final String otp;

  const AuthVerifyOtpRequested({required this.email, required this.otp});

  @override
  List<Object?> get props => [email, otp];
}

/// Event to resend OTP
class AuthResendOtpRequested extends AuthEvent {
  /// The email to resend the OTP to
  final String email;

  const AuthResendOtpRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event to clear any error state
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}

/// Event when user data needs refresh
class AuthRefreshRequested extends AuthEvent {
  const AuthRefreshRequested();
}
