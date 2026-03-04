/// Notification BLoC States
///
/// States representing the current notification status.
library;

import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/entities/notification_entity.dart';

/// Base class for all notification states
sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// Loading state
class NotificationLoading extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationLoading({
    this.notifications = const [],
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

/// Notifications loaded successfully
class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool hasMore;
  final int currentPage;

  const NotificationLoaded({
    required this.notifications,
    this.unreadCount = 0,
    this.hasMore = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, hasMore, currentPage];

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? hasMore,
    int? currentPage,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

/// Loading more notifications (pagination)
class NotificationLoadingMore extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationLoadingMore({
    required this.notifications,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

/// Notification error
class NotificationError extends NotificationState {
  final String message;
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationError({
    required this.message,
    this.notifications = const [],
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [message, notifications, unreadCount];
}

/// Notification operation in progress (mark as read, delete, etc.)
class NotificationOperationInProgress extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String operation;

  const NotificationOperationInProgress({
    required this.notifications,
    this.unreadCount = 0,
    required this.operation,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, operation];
}

/// Notification operation successful
class NotificationOperationSuccess extends NotificationState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final String message;

  const NotificationOperationSuccess({
    required this.notifications,
    this.unreadCount = 0,
    required this.message,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, message];
}
