/// Notification Repository Implementation
///
/// Implements the notification repository interface.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/notification_model.dart';

/// Implementation of notification repository
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getNotifications(
          page: page,
          limit: limit,
        );
        return Right(response.notifications.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    if (await _networkInfo.isConnected) {
      try {
        final count = await _remoteDataSource.getUnreadCount();
        return Right(count);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> markAsRead(
    String notificationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.markAsRead(notificationId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(
    String notificationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteNotification(notificationId);
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markAllAsRead();
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> markAllAsSeen() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.markAllAsSeen();
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, NotificationEntity>> getNotificationById(
    String notificationId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getNotificationById(
          notificationId,
        );
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearAllNotifications() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.clearAllNotifications();
        return const Right(unit);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
