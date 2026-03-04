/// Notification BLoC
///
/// Business Logic Component for notification management.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

/// Notification BLoC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationReadUseCase _markNotificationReadUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final MarkAllNotificationsReadUseCase _markAllAsReadUseCase;
  final GetUnreadNotificationCountUseCase _getUnreadCountUseCase;
  final ClearAllNotificationsUseCase _clearAllUseCase;
  final NotificationRepository _repository;

  static const int _pageSize = 20;

  NotificationBloc({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationReadUseCase markNotificationReadUseCase,
    required DeleteNotificationUseCase deleteNotificationUseCase,
    required MarkAllNotificationsReadUseCase markAllAsReadUseCase,
    required GetUnreadNotificationCountUseCase getUnreadCountUseCase,
    required ClearAllNotificationsUseCase clearAllUseCase,
    required NotificationRepository repository,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markNotificationReadUseCase = markNotificationReadUseCase,
        _deleteNotificationUseCase = deleteNotificationUseCase,
        _markAllAsReadUseCase = markAllAsReadUseCase,
        _getUnreadCountUseCase = getUnreadCountUseCase,
        _clearAllUseCase = clearAllUseCase,
        _repository = repository,
        super(const NotificationInitial()) {
    on<NotificationLoadRequested>(_onLoadRequested);
    on<NotificationLoadMoreRequested>(_onLoadMoreRequested);
    on<NotificationMarkAsReadRequested>(_onMarkAsReadRequested);
    on<NotificationDeleteRequested>(_onDeleteRequested);
    on<NotificationMarkAllAsReadRequested>(_onMarkAllAsReadRequested);
    on<NotificationClearAllRequested>(_onClearAllRequested);
    on<NotificationRefreshRequested>(_onRefreshRequested);
    on<NotificationTappedFromPush>(_onTappedFromPush);
    on<NotificationUnreadCountRequested>(_onUnreadCountRequested);
  }

  /// Load notifications
  Future<void> _onLoadRequested(
    NotificationLoadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await _getNotificationsUseCase(
      const GetNotificationsParams(page: 1, limit: _pageSize),
    );

    final unreadCount = await _getUnreadCount();

    result.fold(
      (failure) => emit(NotificationError(
        message: failure.message,
        unreadCount: unreadCount,
      )),
      (notifications) => emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        hasMore: notifications.length >= _pageSize,
        currentPage: 1,
      )),
    );
  }

  /// Load more notifications (pagination)
  Future<void> _onLoadMoreRequested(
    NotificationLoadMoreRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded || !currentState.hasMore) {
      return;
    }

    emit(NotificationLoadingMore(
      notifications: currentState.notifications,
      unreadCount: currentState.unreadCount,
    ));

    final nextPage = currentState.currentPage + 1;
    final result = await _getNotificationsUseCase(
      GetNotificationsParams(page: nextPage, limit: _pageSize),
    );

    result.fold(
      (failure) => emit(currentState),
      (newNotifications) => emit(NotificationLoaded(
        notifications: [...currentState.notifications, ...newNotifications],
        unreadCount: currentState.unreadCount,
        hasMore: newNotifications.length >= _pageSize,
        currentPage: nextPage,
      )),
    );
  }

  /// Mark notification as read
  Future<void> _onMarkAsReadRequested(
    NotificationMarkAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentNotifications = _getNotificationsFromState();
    final currentUnreadCount = _getUnreadCountFromState();

    emit(NotificationOperationInProgress(
      notifications: currentNotifications,
      unreadCount: currentUnreadCount,
      operation: 'Marking as read...',
    ));

    final result = await _markNotificationReadUseCase(
      MarkNotificationReadParams(notificationId: event.notificationId),
    );

    final unreadCount = await _getUnreadCount();

    result.fold(
      (failure) => emit(NotificationError(
        message: failure.message,
        notifications: currentNotifications,
        unreadCount: unreadCount,
      )),
      (updatedNotification) {
        final updatedNotifications = currentNotifications.map((n) {
          if (n.id == event.notificationId) {
            return updatedNotification;
          }
          return n;
        }).toList();

        emit(NotificationOperationSuccess(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
          message: 'Notification marked as read',
        ));
      },
    );
  }

  /// Delete notification
  Future<void> _onDeleteRequested(
    NotificationDeleteRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentNotifications = _getNotificationsFromState();
    final currentUnreadCount = _getUnreadCountFromState();

    emit(NotificationOperationInProgress(
      notifications: currentNotifications,
      unreadCount: currentUnreadCount,
      operation: 'Deleting...',
    ));

    final result = await _deleteNotificationUseCase(
      DeleteNotificationParams(notificationId: event.notificationId),
    );

    final unreadCount = await _getUnreadCount();

    result.fold(
      (failure) => emit(NotificationError(
        message: failure.message,
        notifications: currentNotifications,
        unreadCount: unreadCount,
      )),
      (_) {
        final updatedNotifications = currentNotifications
            .where((n) => n.id != event.notificationId)
            .toList();

        emit(NotificationOperationSuccess(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
          message: 'Notification deleted',
        ));
      },
    );
  }

  /// Mark all as read
  Future<void> _onMarkAllAsReadRequested(
    NotificationMarkAllAsReadRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentNotifications = _getNotificationsFromState();
    final currentUnreadCount = _getUnreadCountFromState();

    emit(NotificationOperationInProgress(
      notifications: currentNotifications,
      unreadCount: currentUnreadCount,
      operation: 'Marking all as read...',
    ));

    final result = await _markAllAsReadUseCase(const NoParams());

    result.fold(
      (failure) => emit(NotificationError(
        message: failure.message,
        notifications: currentNotifications,
        unreadCount: currentUnreadCount,
      )),
      (_) {
        final updatedNotifications = currentNotifications
            .map((n) => n.copyWith(isRead: true, readAt: DateTime.now()))
            .toList();

        emit(NotificationOperationSuccess(
          notifications: updatedNotifications,
          unreadCount: 0,
          message: 'All notifications marked as read',
        ));
      },
    );
  }

  /// Clear all notifications
  Future<void> _onClearAllRequested(
    NotificationClearAllRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentNotifications = _getNotificationsFromState();

    emit(NotificationOperationInProgress(
      notifications: currentNotifications,
      unreadCount: 0,
      operation: 'Clearing all...',
    ));

    final result = await _clearAllUseCase(const NoParams());

    result.fold(
      (failure) => emit(NotificationError(
        message: failure.message,
        notifications: currentNotifications,
        unreadCount: _getUnreadCountFromState(),
      )),
      (_) => emit(const NotificationLoaded(
        notifications: [],
        unreadCount: 0,
        hasMore: false,
        currentPage: 1,
      )),
    );
  }

  /// Refresh notifications
  Future<void> _onRefreshRequested(
    NotificationRefreshRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    final currentNotifications = currentState is NotificationLoaded
        ? currentState.notifications
        : <NotificationEntity>[];
    final currentUnreadCount = currentState is NotificationLoaded
        ? currentState.unreadCount
        : 0;

    final result = await _getNotificationsUseCase(
      const GetNotificationsParams(page: 1, limit: _pageSize),
    );

    final unreadCount = await _getUnreadCount();

    result.fold(
      (failure) {
        if (currentNotifications.isNotEmpty) {
          emit(NotificationLoaded(
            notifications: currentNotifications,
            unreadCount: unreadCount,
            hasMore: false,
            currentPage: 1,
          ));
        } else {
          emit(NotificationError(
            message: failure.message,
            unreadCount: unreadCount,
          ));
        }
      },
      (notifications) => emit(NotificationLoaded(
        notifications: notifications,
        unreadCount: unreadCount,
        hasMore: notifications.length >= _pageSize,
        currentPage: 1,
      )),
    );
  }

  /// Handle notification tap from push
  Future<void> _onTappedFromPush(
    NotificationTappedFromPush event,
    Emitter<NotificationState> emit,
  ) async {
    // Mark as read when tapped
    if (!event.notificationId.isEmpty) {
      add(NotificationMarkAsReadRequested(notificationId: event.notificationId));
    }
  }

  /// Get unread count
  Future<void> _onUnreadCountRequested(
    NotificationUnreadCountRequested event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    final currentNotifications = currentState is NotificationLoaded
        ? currentState.notifications
        : <NotificationEntity>[];

    final unreadCount = await _getUnreadCount();

    if (currentState is NotificationLoaded) {
      emit(currentState.copyWith(unreadCount: unreadCount));
    } else {
      emit(NotificationLoaded(
        notifications: currentNotifications,
        unreadCount: unreadCount,
      ));
    }
  }

  /// Get notifications from current state
  List<NotificationEntity> _getNotificationsFromState() {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      return currentState.notifications;
    } else if (currentState is NotificationLoadingMore) {
      return currentState.notifications;
    } else if (currentState is NotificationOperationInProgress) {
      return currentState.notifications;
    } else if (currentState is NotificationOperationSuccess) {
      return currentState.notifications;
    } else if (currentState is NotificationError) {
      return currentState.notifications;
    }
    return [];
  }

  /// Get unread count from current state
  int _getUnreadCountFromState() {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      return currentState.unreadCount;
    } else if (currentState is NotificationLoadingMore) {
      return currentState.unreadCount;
    } else if (currentState is NotificationOperationInProgress) {
      return currentState.unreadCount;
    } else if (currentState is NotificationOperationSuccess) {
      return currentState.unreadCount;
    } else if (currentState is NotificationError) {
      return currentState.unreadCount;
    }
    return 0;
  }

  /// Get unread count from repository
  Future<int> _getUnreadCount() async {
    final result = await _getUnreadCountUseCase(const NoParams());
    return result.fold((failure) => 0, (count) => count);
  }
}
