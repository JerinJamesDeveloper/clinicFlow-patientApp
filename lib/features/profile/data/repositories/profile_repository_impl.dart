/// Profile Repository Implementation
///
/// Implements the ProfileRepository interface from the domain layer.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

/// Implementation of ProfileRepository
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    if (!await _networkInfo.isConnected) {
      // Try to get from local storage
      try {
        final localUser = await _localDataSource.getUser();
        if (localUser != null) {
          return Right(localUser.toEntity());
        }
      } catch (_) {}
      return const Left(NetworkFailure());
    }

    try {
      final user = await _remoteDataSource.getProfile();

      // Cache locally
      await _localDataSource.saveUser(user);

      return Right(user.toEntity());
    } on UnauthorizedException {
      return const Left(SessionExpiredFailure());
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
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await _remoteDataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      // Update local cache
      await _localDataSource.saveUser(user);

      return Right(user.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateAvatar(String imagePath) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await _remoteDataSource.updateAvatar(imagePath);

      // Update local cache
      await _localDataSource.saveUser(user);

      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> removeAvatar() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final user = await _remoteDataSource.removeAvatar();

      // Update local cache
      await _localDataSource.saveUser(user);

      return Right(user.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAccount(String password) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteAccount(password);

      // Clear local data
      await _localDataSource.clearAuthData();

      return const Right(unit);
    } on UnauthorizedException {
      return Left(AuthFailure.invalidCredentials());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  int getProfileCompletionPercentage(UserEntity user) {
    int completed = 0;
    const total = 6;

    // Required fields
    if (user.email.isNotEmpty) completed++;
    if (user.firstName.isNotEmpty) completed++;
    if (user.lastName.isNotEmpty) completed++;

    // Optional but recommended
    if (user.isEmailVerified) completed++;
    if (user.phoneNumber?.isNotEmpty ?? false) completed++;
    if (user.avatarUrl?.isNotEmpty ?? false) completed++;

    return ((completed / total) * 100).round();
  }
}
