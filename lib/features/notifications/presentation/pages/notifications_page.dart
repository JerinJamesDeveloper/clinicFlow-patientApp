/// Notifications Page
///
/// Main page for displaying and managing notifications.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/services/notification_handler_service.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/notification_entity.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../widgets/empty_notifications.dart';
import '../widgets/notification_item.dart';
import '../widgets/notification_list.dart';

/// Notifications page
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadNotifications() {
    context.read<NotificationBloc>().add(const NotificationLoadRequested());
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationBloc>().add(const NotificationLoadMoreRequested());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocConsumer<NotificationBloc, NotificationState>(
        listener: _handleState,
        builder: (context, state) {
          return _buildBody(state);
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Notifications'),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            final hasUnread = state is NotificationLoaded && 
                state.notifications.any((n) => !n.isRead);
            
            if (!hasUnread) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'mark_all_read') {
                  context.read<NotificationBloc>()
                      .add(const NotificationMarkAllAsReadRequested());
                } else if (value == 'clear_all') {
                  _showClearAllDialog();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'mark_all_read',
                  child: Row(
                    children: [
                      Icon(Icons.done_all, size: 20),
                      SizedBox(width: 12),
                      Text('Mark all as read'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear_all',
                  child: Row(
                    children: [
                      Icon(Icons.delete_sweep, size: 20),
                      SizedBox(width: 12),
                      Text('Clear all'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _handleState(BuildContext context, NotificationState state) {
    // Handle any side effects like snackbars
    if (state is NotificationOperationSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildBody(NotificationState state) {
    if (state is NotificationLoading) {
      return const LoadingWidget(message: 'Loading notifications...');
    }

    if (state is NotificationError && state.notifications.isEmpty) {
      return ErrorDisplayWidget(
        message: state.message,
        onRetry: _loadNotifications,
      );
    }

    if (state is NotificationLoaded) {
      if (state.notifications.isEmpty) {
        return EmptyNotificationsWidget(
          onRefresh: _loadNotifications,
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<NotificationBloc>()
              .add(const NotificationRefreshRequested());
        },
        child: NotificationList(
          notifications: state.notifications,
          hasMore: state.hasMore,
          isLoading: state is NotificationLoadingMore,
          onTap: _onNotificationTap,
          onMarkAsRead: _onMarkAsRead,
          onDelete: _onDelete,
        ),
      );
    }

    if (state is NotificationLoadingMore) {
      return NotificationList(
        notifications: state.notifications,
        hasMore: true,
        isLoading: true,
        onTap: _onNotificationTap,
        onMarkAsRead: _onMarkAsRead,
        onDelete: _onDelete,
      );
    }

    if (state is NotificationOperationInProgress) {
      return NotificationList(
        notifications: state.notifications,
        hasMore: false,
        isLoading: true,
        onTap: _onNotificationTap,
        onMarkAsRead: _onMarkAsRead,
        onDelete: _onDelete,
      );
    }

    // Initial state - show loading
    return const LoadingWidget(message: 'Loading notifications...');
  }

  void _onNotificationTap(NotificationEntity notification) {
    // Handle navigation based on notification data
    if (notification.data != null) {
      NotificationHandlerService.handleNotificationData(notification.data!);
    }
  }

  void _onMarkAsRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
          NotificationMarkAsReadRequested(notificationId: notification.id),
        );
  }

  void _onDelete(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
          NotificationDeleteRequested(notificationId: notification.id),
        );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotificationBloc>()
                  .add(const NotificationClearAllRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
