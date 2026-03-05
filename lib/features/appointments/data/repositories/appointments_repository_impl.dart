/// Appointments Repository Implementation
///
/// Implements the AppointmentsRepository interface from the domain layer.
/// Coordinates between remote and local data sources.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/appointments_entity.dart';
import '../../domain/repositories/appointments_repository.dart';
import '../datasources/appointments_local_datasource.dart';
import '../datasources/appointments_remote_datasource.dart';

/// Implementation of AppointmentsRepository
class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsRemoteDataSource _remoteDataSource;
  final AppointmentsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  AppointmentsRepositoryImpl({
    required AppointmentsRemoteDataSource remoteDataSource,
    required AppointmentsLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AppointmentsEntity>> getAppointments(String id) async {
    try {
      // Try local first
      final localData = await _localDataSource.getAppointments(id);
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

      final remoteData = await _remoteDataSource.getAppointments(id);
      await _localDataSource.cacheAppointments(remoteData);
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
  Future<Either<Failure, List<AppointmentsEntity>>>
  getAllAppointmentss() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getAllAppointmentss();
      await _localDataSource.cacheAllAppointmentss(remoteData);
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
  Future<Either<Failure, AppointmentsEntity>> createAppointments({
    required String name,
    String? description,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.createAppointments(
        name: name,
        description: description,
      );
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentsEntity>> updateAppointments({
    required String id,
    String? name,
    String? description,
    bool? isActive,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.updateAppointments(
        id: id,
        name: name,
        description: description,
        isActive: isActive,
      );
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteAppointments(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.deleteAppointments(id);
      await _localDataSource.removeAppointments(id);
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
      final remoteData = await _remoteDataSource.getAppointments(id);
      await _localDataSource.cacheAppointments(remoteData);
    } catch (_) {
      // Ignore background refresh errors
    }
  }

  @override
  Future<Either<Failure, List<AppointmentsEntity>>> getDoctors() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getDoctors();
      await _localDataSource.cacheAllAppointmentss(remoteData);
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
  Future<Either<Failure, AppointmentsEntity>> getDoctorDetail({
    required String doctorId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.getDoctorDetail(
        doctorId: doctorId,
      );
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentsEntity>>> getDepartments() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getDepartments();
      await _localDataSource.cacheAllAppointmentss(remoteData);
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
  Future<Either<Failure, List<AppointmentsEntity>>>
  getHospitalBranches() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getHospitalBranches();
      await _localDataSource.cacheAllAppointmentss(remoteData);
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
  Future<Either<Failure, List<AppointmentsEntity>>> getDoctorSchedule({
    required String doctorId,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final result = await _remoteDataSource.getDoctorSchedule(
        doctorId: doctorId,
      );
      await _localDataSource.cacheAllAppointmentss(result);
      return Right(result.map((m) => m.toEntity()).toList());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentsEntity>> getQueueStatus({
    required String doctorId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.getQueueStatus(doctorId: doctorId);
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppointmentsEntity>>>
  getUpcomingAppointments() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getUpcomingAppointments();
      await _localDataSource.cacheAllAppointmentss(remoteData);
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
  Future<Either<Failure, List<AppointmentsEntity>>>
  getPastAppointments() async {
    try {
      if (!await _networkInfo.isConnected) {
        // Return cached data if offline
        final cachedData = await _localDataSource.getAllAppointmentss();
        if (cachedData.isNotEmpty) {
          return Right(cachedData.map((m) => m.toEntity()).toList());
        }
        return const Left(NetworkFailure());
      }

      final remoteData = await _remoteDataSource.getPastAppointments();
      await _localDataSource.cacheAllAppointmentss(remoteData);
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
  Future<Either<Failure, AppointmentsEntity>> getAppointmentDetail({
    required String appointmentId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.getAppointmentDetail(
        appointmentId: appointmentId,
      );
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentsEntity>> createAppointment({
    required String name,
    String? description,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.createAppointment(
        name: name,
        description: description,
      );
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> cancelAppointment({
    required String appointmentId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      await _remoteDataSource.cancelAppointment(appointmentId: appointmentId);
      await _localDataSource.removeAppointments(appointmentId);
      return const Right(unit);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppointmentsEntity>> rescheduleAppointment({
    required String appointmentId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }

    try {
      final result = await _remoteDataSource.rescheduleAppointment(
        appointmentId: appointmentId,
      );
      await _localDataSource.cacheAppointments(result);
      return Right(result.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message, fieldErrors: e.errors));
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
