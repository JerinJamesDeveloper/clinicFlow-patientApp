/// Empty Notifications Widget
///
/// Widget displayed when there are no notifications.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Empty notifications widget
class EmptyNotificationsWidget extends StatelessWidget {
  final VoidCallback? onRefresh;

  const EmptyNotificationsWidget({
    super.key,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 60,
                color: AppColors.grey400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications Yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.grey800,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You\'ll see notifications about your activity here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
            if (onRefresh != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
