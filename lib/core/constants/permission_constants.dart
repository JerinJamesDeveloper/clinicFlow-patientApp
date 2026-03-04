/// Permission Constants
///
/// Contains all permission-related configuration values
/// used throughout the app for requesting and managing permissions.
library;

/// Enum for common permission types with their display names
enum AppPermissionType {
  /// Camera permission
  camera(
    permissionName: 'Camera',
    description: 'Take photos and record videos',
  ),

  /// Microphone permission
  microphone(
    permissionName: 'Microphone',
    description: 'Record audio for videos and voice messages',
  ),

  /// Location permission (when in use)
  locationWhenInUse(
    permissionName: 'Location',
    description: 'Show your location on the map',
  ),

  /// Location permission (always)
  locationAlways(
    permissionName: 'Location',
    description: 'Track your location even when the app is closed',
  ),

  /// Storage permission (photos and videos)
  photos(
    permissionName: 'Photos',
    description: 'Access your photos and videos',
  ),

  /// Storage permission (files)
  storage(
    permissionName: 'Storage',
    description: 'Access files on your device',
  ),

  /// Contacts permission
  contacts(
    permissionName: 'Contacts',
    description: 'Access your contacts list',
  ),

  /// Calendar permission
  calendar(
    permissionName: 'Calendar',
    description: 'Access your calendar events',
  ),

  /// Notification permission
  notifications(
    permissionName: 'Notifications',
    description: 'Receive push notifications',
  );

  const AppPermissionType({
    required this.permissionName,
    required this.description,
  });

  /// Display name for the permission
  final String permissionName;

  /// Brief description of why the permission is needed
  final String description;
}

/// Permission dialog texts
class PermissionDialogTexts {
  // Prevent instantiation
  PermissionDialogTexts._();

  /// Default title for pre-permission dialog
  static const String prePermissionTitle = 'Permission Required';

  /// Default message for pre-permission dialog
  static const String prePermissionMessage =
      'This feature requires access to your {permissionName} to work properly. '
      'We will ask for your permission when you proceed.';

  /// Default title for permission denied dialog
  static const String permissionDeniedTitle = 'Permission Required';

  /// Default message for permission denied dialog
  static const String permissionDeniedMessage =
      'The {permissionName} permission has been denied. '
      'Please enable it in your device settings to use this feature.';

  /// Settings button text
  static const String settingsButton = 'Open Settings';

  /// Cancel button text
  static const String cancelButton = 'Cancel';

  /// Continue button text
  static const String continueButton = 'Continue';

  /// Retry button text
  static const String retryButton = 'Try Again';

  /// Title for permanently denied dialog
  static const String permanentlyDeniedTitle = 'Permission Needed';

  /// Message for permanently denied dialog
  static const String permanentlyDeniedMessage =
      'The {permissionName} permission has been permanently denied. '
      'Please enable it in app settings to use this feature.';
}

/// Permission-related constants
class PermissionConstants {
  // Prevent instantiation
  PermissionConstants._();

  /// Whether to show rationale before requesting permission
  static const bool showPermissionRationale = true;

  /// Delay before requesting permission after showing rationale (ms)
  static const int rationaleDelayMs = 500;

  /// Maximum number of times to request permission before showing settings
  static const int maxPermissionRequests = 2;
}
