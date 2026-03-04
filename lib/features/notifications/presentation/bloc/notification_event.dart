/// Notification BLoC Events
///
/// Events that trigger state changes in the NotificationBloc.
library;

import 'package:equatable/equatable.dart';

/// Base class for all notification events
sealed class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load notifications
class NotificationLoadRequested extends NotificationEvent {
  final bool refresh;

  const NotificationLoadRequested({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

/// Event to load more notifications (pagination)
class NotificationLoadMoreRequested extends NotificationEvent {
  const NotificationLoadMoreRequested();
}

/// Event to mark a notification as read
class NotificationMarkAsReadRequested extends NotificationEvent {
  final String notificationId;

  const NotificationMarkAsReadRequested({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// Event to delete a notification
class NotificationDeleteRequested extends NotificationEvent {
  final String notificationId;

  const NotificationDeleteRequested({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

/// Event to mark all notifications as read
class NotificationMarkAllAsReadRequested extends NotificationEvent {
  const NotificationMarkAllAsReadRequested();
}

/// Event to clear all notifications
class NotificationClearAllRequested extends NotificationEvent {
  const NotificationClearAllRequested();
}

/// Event to refresh notifications
class NotificationRefreshRequested extends NotificationEvent {
  const NotificationRefreshRequested();
}

/// Event when notification is tapped (from push)
class NotificationTappedFromPush extends NotificationEvent {
  final String notificationId;
  final Map<String, dynamic>? data;

  const NotificationTappedFromPush({
    required this.notificationId,
    this.data,
  });

  @override
  List<Object?> get props => [notificationId, data];
}

/// Event to load unread count
class NotificationUnreadCountRequested extends NotificationEvent {
  const NotificationUnreadCountRequested();
}
