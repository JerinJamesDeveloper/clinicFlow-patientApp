/// Auth Repository Implementation
///
/// Implements the AuthRepository interface from the domain layer.
/// Coordinates between remote and local data sources.
library;

import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
// import '../models/user_model.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  /// Stream controller for auth state changes
  final _authStateController = StreamController<UserEntity?>.broadcast();

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Stream<UserEntity?> get authStateChanges => _authStateController.stream;

  @override
  Future<Either<Failure, AuthSessionEntity>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save tokens and user locally
      await _localDataSource.saveTokens(response.tokens);
      await _localDataSource.saveUser(response.user);

      final session = response.toEntity();

      // Notify listeners
      _authStateController.add(session.user);

      return Right(session);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on UnauthorizedException {
      return Left(AuthFailure.invalidCredentials());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final response = await _remoteDataSource.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      // Save tokens and user locally
      await _localDataSource.saveTokens(response.tokens);
      await _localDataSource.saveUser(response.user);

      final session = response.toEntity();

      // Notify listeners
      _authStateController.add(session.user);

      return Right(session);
    } on ValidationException catch (e) {
      // Check for email already exists
      if (e.errors?['email']?.any((e) => e.toLowerCase().contains('exists')) ??
          false) {
        return Left(AuthFailure.emailAlreadyExists());
      }
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      if (e.statusCode == 409 || e.message.toLowerCase().contains('exists')) {
        return Left(AuthFailure.emailAlreadyExists());
      }
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      // Try to logout from server (ignore errors)
      if (await _networkInfo.isConnected) {
        try {
          await _remoteDataSource.logout();
        } catch (_) {
          // Ignore server logout errors
        }
      }

      // Always clear local data
      await _localDataSource.clearAuthData();

      // Notify listeners
      _authStateController.add(null);

      return const Right(unit);
    } catch (e) {
      // Even if there's an error, try to clear local data
      try {
        await _localDataSource.clearAuthData();
        _authStateController.add(null);
      } catch (_) {}

      return const Right(unit);
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      // First try to get from local storage
      final localUser = await _localDataSource.getUser();

      if (localUser != null) {
        // If we have network, refresh from server
        if (await _networkInfo.isConnected) {
          try {
            final remoteUser = await _remoteDataSource.getCurrentUser();
            await _localDataSource.saveUser(remoteUser);
            return Right(remoteUser.toEntity());
          } catch (_) {
            // If refresh fails, return local data
            return Right(localUser.toEntity());
          }
        }
        return Right(localUser.toEntity());
      }

      // No local user, must fetch from server
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      // Check if we have tokens
      final isLoggedIn = await _localDataSource.isLoggedIn();
      if (!isLoggedIn) {
        return const Left(AuthFailure(message: 'Not authenticated'));
      }

      final remoteUser = await _remoteDataSource.getCurrentUser();
      await _localDataSource.saveUser(remoteUser);

      return Right(remoteUser.toEntity());
    } on UnauthorizedException {
      await _localDataSource.clearAuthData();
      _authStateController.add(null);
      return Left(AuthFailure.tokenExpired());
    } on SessionExpiredException {
      await _localDataSource.clearAuthData();
      _authStateController.add(null);
      return Left(AuthFailure.tokenExpired());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on StorageException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      return await _localDataSource.isLoggedIn();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> getSession() async {
    try {
      final tokens = await _localDataSource.getTokens();
      final user = await _localDataSource.getUser();

      if (tokens == null || user == null) {
        return const Left(AuthFailure(message: 'No active session'));
      }

      return Right(
        AuthSessionEntity(user: user.toEntity(), tokens: tokens.toEntity()),
      );
    } on StorageException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokensEntity>> refreshToken() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final currentTokens = await _localDataSource.getTokens();

      if (currentTokens == null) {
        return const Left(AuthFailure(message: 'No refresh token available'));
      }

      final newTokens = await _remoteDataSource.refreshToken(
        currentTokens.refreshToken,
      );

      await _localDataSource.saveTokens(newTokens);

      return Right(newTokens.toEntity());
    } on SessionExpiredException {
      await _localDataSource.clearAuthData();
      _authStateController.add(null);
      return Left(AuthFailure.tokenExpired());
    } on UnauthorizedException {
      await _localDataSource.clearAuthData();
      _authStateController.add(null);
      return Left(AuthFailure.tokenExpired());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword({required String email}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.forgotPassword(email);
      return const Right(unit);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(unit);
    } on UnauthorizedException {
      return Left(UnknownFailure(message: 'Current password is incorrect'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail({required String token}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.verifyEmail(token);

      // Update local user
      final user = await _localDataSource.getUser();
      if (user != null) {
        final updatedUser = user.copyWith(isEmailVerified: true);
        await _localDataSource.saveUser(updatedUser);
        _authStateController.add(updatedUser.toEntity());
      }

      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendVerificationEmail() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.resendVerificationEmail();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      // API returns { token, user } — parse both
      final response = await _remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
      );

      // Save the new token and fresh verified user locally
      await _localDataSource.saveTokens(response.tokens);
      await _localDataSource.saveUser(response.user);

      final session = response.toEntity();

      // Notify listeners with the verified user
      _authStateController.add(session.user);

      return Right(session);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> resendOtp({required String email}) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.resendOtp(email);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? avatarUrl,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final updatedUser = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );

      await _localDataSource.saveUser(updatedUser);

      final entity = updatedUser.toEntity();
      _authStateController.add(entity);

      return Right(entity);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount({
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteAccount(password);
      await _localDataSource.clearAuthData();
      _authStateController.add(null);

      return const Right(unit);
    } on UnauthorizedException {
      return const Left(UnknownFailure(message: 'Password is incorrect'));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
