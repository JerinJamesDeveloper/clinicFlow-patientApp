/// Notification Entity
///
/// Domain entity representing a notification.
library;

import 'package:equatable/equatable.dart';

/// Types of notifications
enum NotificationType {
  /// General information notification
  info,
  
  /// Success notification
  success,
  
  /// Warning notification
  warning,
  
  /// Error/Alert notification
  error,
  
  /// Message from another user
  message,
  
  /// Like/Reaction notification
  like,
  
  /// Comment notification
  comment,
  
  /// Follower notification
  follow,
  
  /// System notification
  system,
}

/// Priority level of notification
enum NotificationPriority {
  /// Low priority
  low,
  
  /// Normal priority
  normal,
  
  /// High priority
  high,
  
  /// Urgent priority
  urgent,
}

/// Notification entity representing a single notification
class NotificationEntity extends Equatable {
  /// Unique identifier
  final String id;
  
  /// Notification title
  final String title;
  
  /// Notification body/message
  final String body;
  
  /// Type of notification
  final NotificationType type;
  
  /// Priority level
  final NotificationPriority priority;
  
  /// Whether the notification has been read
  final bool isRead;
  
  /// Whether the notification has been seen (opened in UI)
  final bool isSeen;
  
  /// Additional data payload (for deep linking, etc.)
  final Map<String, dynamic>? data;
  
  /// URL for associated image (optional)
  final String? imageUrl;
  
  /// Action URL for deep linking (optional)
  final String? actionUrl;
  
  /// Timestamp when the notification was created
  final DateTime createdAt;
  
  /// Timestamp when the notification was read (optional)
  final DateTime? readAt;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.priority = NotificationPriority.normal,
    this.isRead = false,
    this.isSeen = false,
    this.data,
    this.imageUrl,
    this.actionUrl,
    required this.createdAt,
    this.readAt,
  });

  /// Check if notification is new (unread and unseen)
  bool get isNew => !isRead && !isSeen;

  /// Get time ago string for display
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Create a copy with updated fields
  NotificationEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    NotificationPriority? priority,
    bool? isRead,
    bool? isSeen,
    Map<String, dynamic>? data,
    String? imageUrl,
    String? actionUrl,
    DateTime? createdAt,
    DateTime? readAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      isRead: isRead ?? this.isRead,
      isSeen: isSeen ?? this.isSeen,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      actionUrl: actionUrl ?? this.actionUrl,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        priority,
        isRead,
        isSeen,
        data,
        imageUrl,
        actionUrl,
        createdAt,
        readAt,
      ];
}
