/// Get Notifications Use Case
///
/// Use case for retrieving notifications.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

/// Parameters for get notifications use case
class GetNotificationsParams {
  /// Page number for pagination
  final int page;
  
  /// Number of items per page
  final int limit;

  const GetNotificationsParams({
    this.page = 1,
    this.limit = 20,
  });
}

/// Use case for getting notifications
class GetNotificationsUseCase
    implements UseCase<List<NotificationEntity>, GetNotificationsParams> {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    GetNotificationsParams params,
  ) {
    return _repository.getNotifications(
      page: params.page,
      limit: params.limit,
    );
  }
}
