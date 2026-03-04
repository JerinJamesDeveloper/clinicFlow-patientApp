/// Mark Notification Read Use Case
///
/// Use case for marking a notification as read.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Parameters for mark notification as read use case
class MarkNotificationReadParams {
  /// ID of the notification to mark as read
  final String notificationId;

  const MarkNotificationReadParams({required this.notificationId});
}

/// Use case for marking a notification as read
class MarkNotificationReadUseCase
    implements UseCase<NotificationEntity, MarkNotificationReadParams> {
  final NotificationRepository _repository;

  MarkNotificationReadUseCase(this._repository);

  @override
  Future<Either<Failure, NotificationEntity>> call(
    MarkNotificationReadParams params,
  ) {
    return _repository.markAsRead(params.notificationId);
  }
}
