/// Auth BLoC
///
/// Business Logic Component for authentication.
/// Handles all auth-related events and emits appropriate states.
library;

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/resend_verification_email_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final ResendVerificationEmailUseCase _resendVerificationEmailUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required RegisterUseCase registerUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required ChangePasswordUseCase changePasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendOtpUseCase resendOtpUseCase,
    required ResendVerificationEmailUseCase resendVerificationEmailUseCase,
  }) : _loginUseCase = loginUseCase,
       _registerUseCase = registerUseCase,
       _logoutUseCase = logoutUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _forgotPasswordUseCase = forgotPasswordUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _changePasswordUseCase = changePasswordUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resendOtpUseCase = resendOtpUseCase,
       _resendVerificationEmailUseCase = resendVerificationEmailUseCase,
       super(const AuthInitial()) {
    // Register event handlers
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
    on<AuthChangePasswordRequested>(_onChangePasswordRequested);
    on<AuthRefreshRequested>(_onRefreshRequested);
    on<AuthErrorCleared>(_onErrorCleared);
    on<AuthVerifyOtpRequested>(_onVerifyOtpRequested);
    on<AuthResendOtpRequested>(_onResendOtpRequested);
    on<AuthResendVerificationRequested>(_onResendVerificationRequested);
  }

  /// Handles checking current auth status
  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(message: 'Checking authentication...'));

    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) =>
          emit(AuthUnauthenticated(message: _getLogoutMessage(failure))),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  /// Handles login request
  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthOperationInProgress(operation: AuthOperation.login));

    final result = await _loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
        rememberMe: event.rememberMe,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (session) => emit(AuthAuthenticated(user: session.user)),
    );
  }

  /// Handles register request
  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthOperationInProgress(operation: AuthOperation.register));

    final result = await _registerUseCase(
      RegisterParams(
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
        firstName: event.firstName,
        lastName: event.lastName,
        acceptedTerms: event.acceptedTerms,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (session) => emit(AuthAuthenticated(user: session.user)),
    );
  }

  /// Handles logout request
  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthOperationInProgress(operation: AuthOperation.logout));

    final result = await _logoutUseCase();

    result.fold((failure) {
      // Even if logout fails, we should still clear local state
      emit(const AuthUnauthenticated());
    }, (_) => emit(const AuthUnauthenticated()));
  }

  /// Handles forgot password request
  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      const AuthOperationInProgress(operation: AuthOperation.forgotPassword),
    );

    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(AuthPasswordResetSent(email: event.email)),
    );
  }

  /// Handles reset password request
  Future<void> _onResetPasswordRequested(
    AuthResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthOperationInProgress(operation: AuthOperation.resetPassword));

    final result = await _resetPasswordUseCase(
      ResetPasswordParams(
        token: event.token,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (_) => emit(const AuthPasswordResetSuccess()),
    );
  }

  /// Handles change password request
  Future<void> _onChangePasswordRequested(
    AuthChangePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;

    emit(
      const AuthOperationInProgress(operation: AuthOperation.changePassword),
    );

    final result = await _changePasswordUseCase(
      ChangePasswordParams(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
        confirmPassword: event.confirmPassword,
      ),
    );

    result.fold(
      (failure) =>
          emit(_mapFailureToState(failure, previousState: currentState)),
      (_) => emit(const AuthPasswordChangeSuccess()),
    );
  }

  /// Handles refresh user data request
  Future<void> _onRefreshRequested(
    AuthRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Don't show loading, just refresh in background
    final result = await _getCurrentUserUseCase();

    result.fold((failure) {
      if (failure is SessionExpiredFailure) {
        emit(const AuthUnauthenticated(message: 'Session expired'));
      }
      // For other failures, keep current state
    }, (user) => emit(AuthAuthenticated(user: user)));
  }

  /// Handles error cleared event
  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    if (state is AuthError) {
      final errorState = state as AuthError;
      if (errorState.previousState != null) {
        emit(errorState.previousState!);
      } else {
        emit(const AuthUnauthenticated());
      }
    }
  }

  /// Handles OTP verification request
  Future<void> _onVerifyOtpRequested(
    AuthVerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(const AuthOperationInProgress(operation: AuthOperation.verifyOtp));

    final result = await _verifyOtpUseCase(
      VerifyOtpParams(email: event.email, otp: event.otp),
    );

    result.fold(
      (failure) => emit(
        AuthError(message: failure.message, previousState: currentState),
      ),
      // The repository already saved the token + user from the API response.
      // Emit AuthAuthenticated directly — no second /me call needed.
      (session) => emit(AuthAuthenticated(user: session.user)),
    );
  }

  /// Handles OTP resend request
  Future<void> _onResendOtpRequested(
    AuthResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(const AuthOperationInProgress(operation: AuthOperation.resendOtp));

    final result = await _resendOtpUseCase(event.email);

    result.fold(
      (failure) => emit(
        AuthError(message: failure.message, previousState: currentState),
      ),
      (_) => emit(const AuthResendOtpSuccess()),
    );
  }

  Future<void> _onResendVerificationRequested(
    AuthResendVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    emit(
      const AuthOperationInProgress(operation: AuthOperation.resendVerification),
    );

    final result = await _resendVerificationEmailUseCase(const NoParams());

    result.fold(
      (failure) => emit(
        AuthError(message: failure.message, previousState: currentState),
      ),
      (_) => emit(const AuthVerificationEmailSent()),
    );
  }

  /// Maps a failure to an error state
  AuthError _mapFailureToState(Failure failure, {AuthState? previousState}) {
    if (failure is ValidationFailure) {
      return AuthError(
        message: failure.message,
        fieldErrors: failure.fieldErrors,
        previousState: previousState,
      );
    }

    return AuthError(message: failure.message, previousState: previousState);
  }

  /// Gets appropriate message for logout/session failure
  String? _getLogoutMessage(Failure failure) {
    if (failure is SessionExpiredFailure) {
      return 'Your session has expired. Please login again.';
    }
    return null;
  }
}
