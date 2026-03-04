/// Notification Item Widget
///
/// Widget for displaying a single notification item.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_entity.dart';

/// Notification item widget
class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onDelete;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Container(
        color: notification.isNew
            ? AppColors.primary.withOpacity(0.05)
            : Colors.transparent,
        child: ListTile(
          onTap: () {
            if (!notification.isRead) {
              onMarkAsRead?.call();
            }
            onTap?.call();
          },
          leading: _buildLeadingIcon(),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight:
                  notification.isNew ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notification.timeAgo,
                style: TextStyle(
                  color: AppColors.grey400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          trailing: notification.isNew
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          isThreeLine: true,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.info:
        icon = Icons.info_outline;
        iconColor = AppColors.info;
        break;
      case NotificationType.success:
        icon = Icons.check_circle_outline;
        iconColor = AppColors.success;
        break;
      case NotificationType.warning:
        icon = Icons.warning_amber_outlined;
        iconColor = AppColors.warning;
        break;
      case NotificationType.error:
        icon = Icons.error_outline;
        iconColor = AppColors.error;
        break;
      case NotificationType.message:
        icon = Icons.message_outlined;
        iconColor = AppColors.primary;
        break;
      case NotificationType.like:
        icon = Icons.favorite_outline;
        iconColor = AppColors.error;
        break;
      case NotificationType.comment:
        icon = Icons.comment_outlined;
        iconColor = AppColors.info;
        break;
      case NotificationType.follow:
        icon = Icons.person_add_outlined;
        iconColor = AppColors.primary;
        break;
      case NotificationType.system:
        icon = Icons.settings_outlined;
        iconColor = AppColors.grey600;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 24,
      ),
    );
  }
}
