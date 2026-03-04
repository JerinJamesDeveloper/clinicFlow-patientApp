/// Permission Dialog Widgets
///
/// Pre-permission explanation dialog and permission denied dialog
/// for explaining why permissions are needed.
library;

import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/permission_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pre-permission explanation dialog
///
/// Shows a dialog explaining why a permission is needed before
/// the system permission dialog appears.
class PrePermissionDialog extends StatelessWidget {
  /// The permission type being requested
  final AppPermissionType permissionType;

  /// Custom title text (optional)
  final String? title;

  /// Custom message text (optional)
  final String? message;

  /// Custom continue button text (optional)
  final String? continueButtonText;

  /// Custom cancel button text (optional)
  final String? cancelButtonText;

  /// Callback when user taps continue
  final VoidCallback? onContinue;

  /// Callback when user taps cancel
  final VoidCallback? onCancel;

  /// Custom icon (optional)
  final IconData? icon;

  const PrePermissionDialog({
    super.key,
    required this.permissionType,
    this.title,
    this.message,
    this.continueButtonText,
    this.cancelButtonText,
    this.onContinue,
    this.onCancel,
    this.icon,
  });

  /// Show the pre-permission dialog
  ///
  /// Returns true if user tapped continue, false otherwise.
  static Future<bool> show({
    required BuildContext context,
    required AppPermissionType permissionType,
    String? title,
    String? message,
    String? continueButtonText,
    String? cancelButtonText,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PrePermissionDialog(
        permissionType: permissionType,
        title: title,
        message: message,
        continueButtonText: continueButtonText,
        cancelButtonText: cancelButtonText,
        icon: icon,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.largePadding),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon ?? _getIconForPermission(permissionType),
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Title
          Text(
            title ?? PermissionDialogTexts.prePermissionTitle,
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding),

          // Message
          Text(
            message ?? PermissionDialogTexts.prePermissionMessage.replaceAll(
              '{permissionName}',
              permissionType.permissionName,
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(
            cancelButtonText ?? PermissionDialogTexts.cancelButton,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),

        // Continue button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onContinue?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: Text(
            continueButtonText ?? PermissionDialogTexts.continueButton,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }

  /// Get appropriate icon for permission type
  IconData _getIconForPermission(AppPermissionType permissionType) {
    switch (permissionType) {
      case AppPermissionType.camera:
        return Icons.camera_alt_outlined;
      case AppPermissionType.microphone:
        return Icons.mic_outlined;
      case AppPermissionType.locationWhenInUse:
      case AppPermissionType.locationAlways:
        return Icons.location_on_outlined;
      case AppPermissionType.photos:
        return Icons.photo_library_outlined;
      case AppPermissionType.storage:
        return Icons.folder_outlined;
      case AppPermissionType.contacts:
        return Icons.contacts_outlined;
      case AppPermissionType.calendar:
        return Icons.calendar_today_outlined;
      case AppPermissionType.notifications:
        return Icons.notifications_outlined;
    }
  }
}

/// Permission denied dialog
///
/// Shows when a permission has been denied and user needs to
/// go to settings to enable it.
class PermissionDeniedDialog extends StatelessWidget {
  /// The permission type that was denied
  final AppPermissionType permissionType;

  /// Custom title text (optional)
  final String? title;

  /// Custom message text (optional)
  final String? message;

  /// Custom settings button text (optional)
  final String? settingsButtonText;

  /// Custom cancel button text (optional)
  final String? cancelButtonText;

  /// Callback when user taps settings
  final VoidCallback? onOpenSettings;

  /// Callback when user taps cancel
  final VoidCallback? onCancel;

  const PermissionDeniedDialog({
    super.key,
    required this.permissionType,
    this.title,
    this.message,
    this.settingsButtonText,
    this.cancelButtonText,
    this.onOpenSettings,
    this.onCancel,
  });

  /// Show the permission denied dialog
  ///
  /// Returns true if user tapped settings, false otherwise.
  static Future<bool> show({
    required BuildContext context,
    required AppPermissionType permissionType,
    String? title,
    String? message,
    String? settingsButtonText,
    String? cancelButtonText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionDeniedDialog(
        permissionType: permissionType,
        title: title,
        message: message,
        settingsButtonText: settingsButtonText,
        cancelButtonText: cancelButtonText,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.largePadding),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 32,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Title
          Text(
            title ?? PermissionDialogTexts.permissionDeniedTitle,
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding),

          // Message
          Text(
            message ?? PermissionDialogTexts.permissionDeniedMessage.replaceAll(
              '{permissionName}',
              permissionType.permissionName,
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(
            cancelButtonText ?? PermissionDialogTexts.cancelButton,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),

        // Settings button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onOpenSettings?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: Text(
            settingsButtonText ?? PermissionDialogTexts.settingsButton,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}

/// Permission permanently denied dialog
///
/// Shows when a permission has been permanently denied and user
/// must go to settings to enable it.
class PermissionPermanentlyDeniedDialog extends StatelessWidget {
  /// The permission type that was permanently denied
  final AppPermissionType permissionType;

  /// Custom title text (optional)
  final String? title;

  /// Custom message text (optional)
  final String? message;

  /// Custom settings button text (optional)
  final String? settingsButtonText;

  /// Custom cancel button text (optional)
  final String? cancelButtonText;

  /// Callback when user taps settings
  final VoidCallback? onOpenSettings;

  /// Callback when user taps cancel
  final VoidCallback? onCancel;

  const PermissionPermanentlyDeniedDialog({
    super.key,
    required this.permissionType,
    this.title,
    this.message,
    this.settingsButtonText,
    this.cancelButtonText,
    this.onOpenSettings,
    this.onCancel,
  });

  /// Show the permission permanently denied dialog
  ///
  /// Returns true if user tapped settings, false otherwise.
  static Future<bool> show({
    required BuildContext context,
    required AppPermissionType permissionType,
    String? title,
    String? message,
    String? settingsButtonText,
    String? cancelButtonText,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PermissionPermanentlyDeniedDialog(
        permissionType: permissionType,
        title: title,
        message: message,
        settingsButtonText: settingsButtonText,
        cancelButtonText: cancelButtonText,
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
      ),
      contentPadding: const EdgeInsets.all(AppConstants.largePadding),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.settings_outlined,
              size: 32,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),

          // Title
          Text(
            title ?? PermissionDialogTexts.permanentlyDeniedTitle,
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding),

          // Message
          Text(
            message ?? PermissionDialogTexts.permanentlyDeniedMessage.replaceAll(
              '{permissionName}',
              permissionType.permissionName,
            ),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(
            cancelButtonText ?? PermissionDialogTexts.cancelButton,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),

        // Settings button
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onOpenSettings?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
            ),
          ),
          child: Text(
            settingsButtonText ?? PermissionDialogTexts.settingsButton,
            style: AppTextStyles.buttonMedium.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ],
    );
  }
}
