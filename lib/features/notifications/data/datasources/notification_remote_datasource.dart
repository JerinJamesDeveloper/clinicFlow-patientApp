/// Notification Remote Data Source
///
/// Abstract class for remote notification data operations.
library;

import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../models/notification_model.dart';

/// Abstract class defining notification remote data source contract
abstract class NotificationRemoteDataSource {
  /// Get all notifications
  Future<NotificationListResponse> getNotifications({
    int page = 1,
    int limit = 20,
  });

  /// Get unread notification count
  Future<int> getUnreadCount();

  /// Mark notification as read
  Future<NotificationModel> markAsRead(String notificationId);

  /// Delete notification
  Future<void> deleteNotification(String notificationId);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Mark all notifications as seen
  Future<void> markAllAsSeen();

  /// Get notification by ID
  Future<NotificationModel> getNotificationById(String notificationId);

  /// Clear all notifications
  Future<void> clearAllNotifications();

  /// Register device token for push notifications
  Future<void> registerDeviceToken(String token);

  /// Unregister device token
  Future<void> unregisterDeviceToken(String token);
}

/// Implementation of notification remote data source
class NotificationRemoteDataSourceImpl
    implements NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSourceImpl(this._dioClient);

  @override
  Future<NotificationListResponse> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.notifications,
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return NotificationListResponse.fromJson(response.data);
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _dioClient.get(
      '${ApiEndpoints.notifications}/unread-count',
    );
    return response.data['count'] as int? ?? 0;
  }

  @override
  Future<NotificationModel> markAsRead(String notificationId) async {
    final response = await _dioClient.patch(
      '${ApiEndpoints.notifications}/$notificationId/read',
    );
    return NotificationModel.fromJson(response.data);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await _dioClient.delete(
      '${ApiEndpoints.notifications}/$notificationId',
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _dioClient.patch(
      '${ApiEndpoints.notifications}/read-all',
    );
  }

  @override
  Future<void> markAllAsSeen() async {
    await _dioClient.patch(
      '${ApiEndpoints.notifications}/seen-all',
    );
  }

  @override
  Future<NotificationModel> getNotificationById(
    String notificationId,
  ) async {
    final response = await _dioClient.get(
      '${ApiEndpoints.notifications}/$notificationId',
    );
    return NotificationModel.fromJson(response.data);
  }

  @override
  Future<void> clearAllNotifications() async {
    await _dioClient.delete(ApiEndpoints.notifications);
  }

  @override
  Future<void> registerDeviceToken(String token) async {
    await _dioClient.post(
      '${ApiEndpoints.notifications}/device-token',
      data: {'token': token},
    );
  }

  @override
  Future<void> unregisterDeviceToken(String token) async {
    await _dioClient.delete(
      '${ApiEndpoints.notifications}/device-token',
      data: {'token': token},
    );
  }
}
