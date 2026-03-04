/// Mark All Notifications Read Use Case
///
/// Use case for marking all notifications as read.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// Use case for marking all notifications as read
class MarkAllNotificationsReadUseCase implements UseCase<Unit, NoParams> {
  final NotificationRepository _repository;

  MarkAllNotificationsReadUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.markAllAsRead();
  }
}

/// Use case for marking all notifications as seen
class MarkAllNotificationsSeenUseCase implements UseCase<Unit, NoParams> {
  final NotificationRepository _repository;

  MarkAllNotificationsSeenUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.markAllAsSeen();
  }
}

/// Use case for getting unread notification count
class GetUnreadNotificationCountUseCase implements UseCase<int, NoParams> {
  final NotificationRepository _repository;

  GetUnreadNotificationCountUseCase(this._repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return _repository.getUnreadCount();
  }
}

/// Use case for clearing all notifications
class ClearAllNotificationsUseCase implements UseCase<Unit, NoParams> {
  final NotificationRepository _repository;

  ClearAllNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.clearAllNotifications();
  }
}
