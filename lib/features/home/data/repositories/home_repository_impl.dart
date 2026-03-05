/// Home Repository Implementation
///
/// Implements the HomeRepository interface from the domain layer.
/// Coordinates between remote and local data sources.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

/// Implementation of HomeRepository
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required HomeLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, HomeEntity>> getHome(String id) async {
    try {
      // Try local first
      final localData = await _localDataSource.getHome(id);
      if (localData != null) {
        // If online, refresh in background
        if (await _networkInfo.isConnected) {
          _refreshFromRemote(id);
        }
        return Right(localData.toEntity());
      }

      // No local data, fetch from remote
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getHome(id);
      await _localDataSource.cacheHome(remoteData);
      return Right(remoteData.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on StorageException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllHomes() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllHomes();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getAllHomes();
      await _localDataSource.cacheAllHomes(remoteData);
      return Right(remoteData.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> createHome({
    required String name,
    String? description,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.createHome(
        name: name,
        description: description,
      );
      await _localDataSource.cacheHome(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.errors,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> updateHome({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.updateHome(
        id: id,
        name: name,
        description: description,
        isActive: isActive,
      );
      await _localDataSource.cacheHome(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.errors,
      ));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteHome(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteHome(id);
      await _localDataSource.removeHome(id);
      return const Right(unit);
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Refresh data from remote in background
  Future<void> _refreshFromRemote(String id) async {
    try {
      final remoteData = await _remoteDataSource.getHome(id);
      await _localDataSource.cacheHome(remoteData);
    } catch (_) {
      // Ignore background refresh errors
    }
  }

  @override
  Future<Either<Failure, HomeEntity>> getHomeSummary(String id) async {
    try {
      // Try local first
      final localData = await _localDataSource.getHome(id);
      if (localData != null) {
        // If online, refresh in background
        if (await _networkInfo.isConnected) {
          _refreshFromRemote(id);
        }
        return Right(localData.toEntity());
      }

      // No local data, fetch from remote
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getHomeSummary(id);
      await _localDataSource.cacheHome(remoteData);
      return Right(remoteData.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } on StorageException {
      return const Left(CacheFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<HomeEntity>>> getHealthAlerts() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllHomes();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getHealthAlerts();
      await _localDataSource.cacheAllHomes(remoteData);
      return Right(remoteData.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }


  @override
  Future<Either<Failure, List<HomeEntity>>> getUpcomingAppointments() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllHomes();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getUpcomingAppointments();
      await _localDataSource.cacheAllHomes(remoteData);
      return Right(remoteData.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

}
