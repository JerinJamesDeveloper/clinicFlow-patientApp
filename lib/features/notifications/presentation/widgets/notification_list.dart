/// Notification List Widget
///
/// Widget for displaying a list of notifications.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';
import 'notification_item.dart';

/// Notification list widget
class NotificationList extends StatelessWidget {
  final List<NotificationEntity> notifications;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final void Function(NotificationEntity)? onTap;
  final void Function(NotificationEntity)? onMarkAsRead;
  final void Function(NotificationEntity)? onDelete;

  const NotificationList({
    super.key,
    required this.notifications,
    this.isLoading = false,
    this.hasMore = false,
    this.onLoadMore,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty && !isLoading) {
      return const SizedBox.shrink();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: notifications.length + (hasMore ? 1 : 0),
      separatorBuilder: (context, index) => Divider(
        height: 1,
        indent: 72,
        color: AppColors.grey200,
      ),
      itemBuilder: (context, index) {
        // Load more indicator
        if (index == notifications.length) {
          return _buildLoadMoreIndicator();
        }

        final notification = notifications[index];
        return NotificationItem(
          notification: notification,
          onTap: () => onTap?.call(notification),
          onMarkAsRead: () => onMarkAsRead?.call(notification),
          onDelete: () => onDelete?.call(notification),
        );
      },
    );
  }

  Widget _buildLoadMoreIndicator() {
    if (!hasMore || !isLoading) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
