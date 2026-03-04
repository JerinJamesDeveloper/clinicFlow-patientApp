/// Delete Notification Use Case
///
/// Use case for deleting a notification.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// Parameters for delete notification use case
class DeleteNotificationParams {
  /// ID of the notification to delete
  final String notificationId;

  const DeleteNotificationParams({required this.notificationId});
}

/// Use case for deleting a notification
class DeleteNotificationUseCase
    implements UseCase<Unit, DeleteNotificationParams> {
  final NotificationRepository _repository;

  DeleteNotificationUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteNotificationParams params) {
    return _repository.deleteNotification(params.notificationId);
  }
}
