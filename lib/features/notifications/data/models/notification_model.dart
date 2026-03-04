/// Notification Model
///
/// Data model for notification with JSON serialization.
library;

import '../../domain/entities/notification_entity.dart';

/// Notification model for API communication
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.type,
    super.priority,
    super.isRead,
    super.isSeen,
    super.data,
    super.imageUrl,
    super.actionUrl,
    required super.createdAt,
    super.readAt,
  });

  /// Create from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: _parseNotificationType(json['type'] as String?),
      priority: _parsePriority(json['priority'] as String?),
      isRead: json['is_read'] as bool? ?? false,
      isSeen: json['is_seen'] as bool? ?? false,
      data: json['data'] as Map<String, dynamic>?,
      imageUrl: json['image_url'] as String?,
      actionUrl: json['action_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.name,
      'priority': priority.name,
      'is_read': isRead,
      'is_seen': isSeen,
      'data': data,
      'image_url': imageUrl,
      'action_url': actionUrl,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  /// Create from entity
  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      priority: entity.priority,
      isRead: entity.isRead,
      isSeen: entity.isSeen,
      data: entity.data,
      imageUrl: entity.imageUrl,
      actionUrl: entity.actionUrl,
      createdAt: entity.createdAt,
      readAt: entity.readAt,
    );
  }

  /// Parse notification type from string
  static NotificationType _parseNotificationType(String? type) {
    switch (type) {
      case 'info':
        return NotificationType.info;
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      case 'message':
        return NotificationType.message;
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.info;
    }
  }

  /// Parse priority from string
  static NotificationPriority _parsePriority(String? priority) {
    switch (priority) {
      case 'low':
        return NotificationPriority.low;
      case 'normal':
        return NotificationPriority.normal;
      case 'high':
        return NotificationPriority.high;
      case 'urgent':
        return NotificationPriority.urgent;
      default:
        return NotificationPriority.normal;
    }
  }

  /// Convert to entity
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      priority: priority,
      isRead: isRead,
      isSeen: isSeen,
      data: data,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      createdAt: createdAt,
      readAt: readAt,
    );
  }
}

/// Pagination response model for notifications
class NotificationListResponse {
  /// List of notifications
  final List<NotificationModel> notifications;
  
  /// Current page
  final int page;
  
  /// Total pages
  final int totalPages;
  
  /// Total count
  final int totalCount;
  
  /// Has more pages
  final bool hasMore;

  const NotificationListResponse({
    required this.notifications,
    required this.page,
    required this.totalPages,
    required this.totalCount,
    required this.hasMore,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      notifications: (json['notifications'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalCount: json['total_count'] as int? ?? 0,
      hasMore: json['has_more'] as bool? ?? false,
    );
  }
}
