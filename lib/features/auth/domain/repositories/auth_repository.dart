/// Auth Repository Interface
///
/// Abstract repository defining the contract for authentication operations.
/// This interface is implemented by the data layer.
library;

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';

/// Abstract repository interface for authentication operations
abstract class AuthRepository {
  /// Authenticates a user with email and password
  ///
  /// Returns [AuthSessionEntity] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [InvalidCredentialsFailure] - Wrong email or password
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error
  /// - [ValidationFailure] - Invalid input data
  Future<Either<Failure, AuthSessionEntity>> login({
    required String email,
    required String password,
  });

  /// Registers a new user account
  ///
  /// Returns [AuthSessionEntity] on success or [Failure] on error.
  ///
  /// Possible failures:
  /// - [EmailAlreadyExistsFailure] - Email already registered
  /// - [NetworkFailure] - No internet connection
  /// - [ServerFailure] - Server error
  /// - [ValidationFailure] - Invalid input data
  Future<Either<Failure, AuthSessionEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  /// Logs out the current user
  ///
  /// Returns [Unit] (void) on success or [Failure] on error.
  ///
  /// This method should:
  /// - Clear local tokens
  /// - Invalidate server session
  /// - Clear cached user data
  Future<Either<Failure, Unit>> logout();

  /// Gets the currently authenticated user
  ///
  /// Returns [UserEntity] on success or [Failure] on error.
  ///
  /// This method first checks local cache, then fetches from server.
  ///
  /// Possible failures:
  /// - [AuthFailure] - Not authenticated
  /// - [SessionExpiredFailure] - Session has expired
  /// - [NetworkFailure] - No internet connection
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Checks if a user is currently authenticated
  ///
  /// Returns true if user has valid tokens stored locally.
  /// This is a quick check that doesn't verify with the server.
  Future<bool> isAuthenticated();

  /// Gets the current authentication session
  ///
  /// Returns [AuthSessionEntity] if user is authenticated,
  /// or [Failure] if not authenticated or session expired.
  Future<Either<Failure, AuthSessionEntity>> getSession();

  /// Refreshes the authentication tokens
  ///
  /// Returns new [AuthTokensEntity] on success or [Failure] on error.
  ///
  /// This is called automatically when access token is about to expire.
  Future<Either<Failure, AuthTokensEntity>> refreshToken();

  /// Initiates password reset process
  ///
  /// Sends a password reset email to the specified email address.
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> forgotPassword({required String email});

  /// Resets password with token from email
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Changes password for authenticated user
  ///
  /// Requires current password for verification.
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Verifies email with token
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> verifyEmail({required String token});

  /// Resends email verification
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> resendVerificationEmail();

  /// Verifies OTP code — returns the authenticated session on success
  Future<Either<Failure, AuthSessionEntity>> verifyOtp({
    required String email,
    required String otp,
  });

  /// Resends OTP code to email
  Future<Either<Failure, Unit>> resendOtp({required String email});

  /// Updates user profile
  ///
  /// Returns updated [UserEntity] on success or [Failure] on error.
  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Deletes the user account
  ///
  /// This is a destructive action that cannot be undone.
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> deleteAccount({required String password});

  /// Stream of authentication state changes
  ///
  /// Emits [UserEntity] when user logs in or updates profile,
  /// emits null when user logs out.
  Stream<UserEntity?> get authStateChanges;
}
