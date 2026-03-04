/// Profile Header Widget
/// 
/// Header section for profile page with avatar, name, and email.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../auth/domain/entities/user_entity.dart';
import 'profile_avatar.dart';

/// Profile header with user info
class ProfileHeader extends StatelessWidget {
  /// User entity
  final UserEntity user;
  
  /// Avatar edit callback
  final VoidCallback? onAvatarEdit;
  
  /// Whether avatar is loading
  final bool isAvatarLoading;
  
  /// Profile completion percentage
  final int completionPercentage;
  
  /// Whether to show completion indicator
  final bool showCompletionIndicator;

  const ProfileHeader({
    super.key,
    required this.user,
    this.onAvatarEdit,
    this.isAvatarLoading = false,
    this.completionPercentage = 0,
    this.showCompletionIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          ProfileAvatar(
            user: user,
            size: 100,
            showEditButton: onAvatarEdit != null,
            onEdit: onAvatarEdit,
            isLoading: isAvatarLoading,
          ),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            user.fullName,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // Email with verification badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
              if (user.isEmailVerified) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.verified_rounded,
                  size: 16,
                  color: AppColors.success,
                ),
              ],
            ],
          ),
          
          // Role badge
          if (user.isAdmin) ...[
            const SizedBox(height: 12),
            _RoleBadge(role: user.role),
          ],
          
          // Completion indicator
          if (showCompletionIndicator && completionPercentage < 100) ...[
            const SizedBox(height: 20),
            _ProfileCompletionIndicator(
              percentage: completionPercentage,
            ),
          ],
        ],
      ),
    );
  }
}

/// Role badge widget
class _RoleBadge extends StatelessWidget {
  final UserRole role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    
    switch (role) {
      case UserRole.admin:
        backgroundColor = AppColors.primary.withOpacity(0.1);
        textColor = AppColors.primary;
        break;
      case UserRole.user:
      default:
        backgroundColor = AppColors.grey100;
        textColor = AppColors.grey600;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            role == UserRole.admin
                ? Icons.admin_panel_settings_rounded
                : Icons.person_outline_rounded,
            size: 14,
            color: textColor,
          ),
          const SizedBox(width: 4),
          Text(
            role.displayName,
            style: AppTextStyles.labelSmall.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile completion indicator
class _ProfileCompletionIndicator extends StatelessWidget {
  final int percentage;

  const _ProfileCompletionIndicator({required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warningLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          // Progress circle
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 4,
                  backgroundColor: AppColors.warning.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.warning),
                ),
                Text(
                  '$percentage%',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.warningDark,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your profile',
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.warningDark,
                  ),
                ),
                Text(
                  'Add more info to unlock all features',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.warningDark.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: AppColors.warningDark,
          ),
        ],
      ),
    );
  }
}

/// Compact profile header for inner pages
class CompactProfileHeader extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onTap;

  const CompactProfileHeader({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            ProfileAvatar(
              user: user,
              size: 56,
              showEditButton: false,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.grey400,
            ),
          ],
        ),
      ),
    );
  }
}