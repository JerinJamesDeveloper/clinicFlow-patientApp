/// Notification Repository Interface
///
/// Abstract repository defining the contract for notification operations.
/// Implemented by the data layer.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/notification_entity.dart';

/// Abstract repository interface for notification operations
abstract class NotificationRepository {
  /// Gets all notifications for the current user
  ///
  /// [page] - Page number for pagination
  /// [limit] - Number of items per page
  /// Returns list of [NotificationEntity] on success or [Failure] on error.
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int limit = 20,
  });

  /// Gets unread notification count
  ///
  /// Returns count on success or [Failure] on error.
  Future<Either<Failure, int>> getUnreadCount();

  /// Marks a notification as read
  ///
  /// [notificationId] - ID of the notification to mark as read
  /// Returns updated [NotificationEntity] on success or [Failure] on error.
  Future<Either<Failure, NotificationEntity>> markAsRead(
    String notificationId,
  );

  /// Marks a notification as deleted
  ///
  /// [notificationId] - ID of the notification to delete
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> deleteNotification(String notificationId);

  /// Marks all notifications as read
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> markAllAsRead();

  /// Marks all notifications as seen (opened in UI)
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> markAllAsSeen();

  /// Gets a single notification by ID
  ///
  /// [notificationId] - ID of the notification
  /// Returns [NotificationEntity] on success or [Failure] on error.
  Future<Either<Failure, NotificationEntity>> getNotificationById(
    String notificationId,
  );

  /// Clears all notifications for the current user
  ///
  /// Returns [Unit] on success or [Failure] on error.
  Future<Either<Failure, Unit>> clearAllNotifications();
}
