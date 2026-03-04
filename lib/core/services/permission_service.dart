/// Permission Service
///
/// Handles all permission-related operations in the app.
/// Provides methods for checking, requesting, and managing permissions.
library;

import 'package:permission_handler/permission_handler.dart' as ph;

import '../constants/permission_constants.dart';

/// Result of a permission check or request
class PermissionResult {
  /// Whether the permission was granted
  final bool isGranted;

  /// Whether the permission is permanently denied
  final bool isPermanentlyDenied;

  /// The permission status
  final ph.PermissionStatus status;

  /// Error message if any
  final String? errorMessage;

  const PermissionResult({
    required this.isGranted,
    required this.isPermanentlyDenied,
    required this.status,
    this.errorMessage,
  });

  /// Factory for granted result
  factory PermissionResult.granted() => const PermissionResult(
        isGranted: true,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.granted,
      );

  /// Factory for denied result
  factory PermissionResult.denied({
    ph.PermissionStatus status = ph.PermissionStatus.denied,
  }) =>
      PermissionResult(
        isGranted: false,
        isPermanentlyDenied: false,
        status: status,
      );

  /// Factory for permanently denied result
  factory PermissionResult.permanentlyDenied({
    ph.PermissionStatus status = ph.PermissionStatus.permanentlyDenied,
  }) =>
      PermissionResult(
        isGranted: false,
        isPermanentlyDenied: true,
        status: status,
      );

  /// Factory for restricted result (iOS only)
  factory PermissionResult.restricted() => const PermissionResult(
        isGranted: false,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.restricted,
      );

  /// Factory for limited result (iOS only)
  factory PermissionResult.limited() => const PermissionResult(
        isGranted: true,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.limited,
      );

  /// Factory for error result
  factory PermissionResult.error(String message) => PermissionResult(
        isGranted: false,
        isPermanentlyDenied: false,
        status: ph.PermissionStatus.denied,
        errorMessage: message,
      );
}

/// Service for handling app permissions
class PermissionService {
  /// Map of app permission types to permission_handler permissions
  static final Map<AppPermissionType, ph.Permission> _permissionMap = {
    AppPermissionType.camera: ph.Permission.camera,
    AppPermissionType.microphone: ph.Permission.microphone,
    AppPermissionType.locationWhenInUse: ph.Permission.locationWhenInUse,
    AppPermissionType.locationAlways: ph.Permission.locationAlways,
    AppPermissionType.photos: ph.Permission.photos,
    AppPermissionType.storage: ph.Permission.storage,
    AppPermissionType.contacts: ph.Permission.contacts,
    AppPermissionType.calendar: ph.Permission.calendar,
    AppPermissionType.notifications: ph.Permission.notification,
  };

  /// Check if a permission is granted
  /// Returns true if the permission is granted, false otherwise
  Future<bool> isGranted(AppPermissionType permissionType) async {
    final permission = _permissionMap[permissionType];
    if (permission == null) {
      return false;
    }

    final status = await permission.status;
    return status.isGranted;
  }

  /// Check the current status of a permission
  Future<ph.PermissionStatus> getStatus(AppPermissionType permissionType) async {
    final permission = _permissionMap[permissionType];
    if (permission == null) {
      return ph.PermissionStatus.denied;
    }

    return permission.status;
  }

  /// Request a single permission
  /// Returns a [PermissionResult] with the result of the request
  Future<PermissionResult> request(AppPermissionType permissionType) async {
    final permission = _permissionMap[permissionType];
    if (permission == null) {
      return PermissionResult.error('Unknown permission type: $permissionType');
    }

    try {
      final status = await permission.request();

      if (status.isGranted) {
        return PermissionResult.granted();
      } else if (status.isPermanentlyDenied) {
        return PermissionResult.permanentlyDenied(status: status);
      } else if (status.isLimited) {
        return PermissionResult.limited();
      } else if (status.isRestricted) {
        return PermissionResult.restricted();
      } else {
        return PermissionResult.denied(status: status);
      }
    } catch (e) {
      return PermissionResult.error('Error requesting permission: $e');
    }
  }

  /// Request multiple permissions at once
  /// Returns a map of permission types to their results
  Future<Map<AppPermissionType, PermissionResult>> requestMultiple(
    List<AppPermissionType> permissionTypes,
  ) async {
    final results = <AppPermissionType, PermissionResult>{};

    for (final type in permissionTypes) {
      results[type] = await request(type);
    }

    return results;
  }

  /// Check if a permission is permanently denied
  /// Returns true if the permission is permanently denied
  Future<bool> isPermanentlyDenied(AppPermissionType permissionType) async {
    final permission = _permissionMap[permissionType];
    if (permission == null) {
      return false;
    }

    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// Check if permission should show rationale
  /// This is useful for determining if we should show an explanation dialog
  Future<bool> shouldShowRationale(AppPermissionType permissionType) async {
    final permission = _permissionMap[permissionType];
    if (permission == null) {
      return false;
    }

    return permission.shouldShowRequestRationale;
  }

  /// Open app settings
  /// Returns true if settings were opened successfully
  Future<bool> openSettings() async {
    return ph.openAppSettings();
  }

  /// Request permission with pre-permission explanation
  /// This method handles the complete flow:
  /// 1. Check if already granted
  /// 2. Check if should show rationale (pre-permission dialog)
  /// 3. Request permission
  /// 4. Handle result
  Future<PermissionResult> requestWithRationale({
    required AppPermissionType permissionType,
    required String rationaleTitle,
    required String rationaleMessage,
    bool showRationale = PermissionConstants.showPermissionRationale,
  }) async {
    // First check if already granted
    if (await isGranted(permissionType)) {
      return PermissionResult.granted();
    }

    // Check if permanently denied (go directly to settings)
    if (await isPermanentlyDenied(permissionType)) {
      return PermissionResult.permanentlyDenied();
    }

    // Check if should show rationale
    if (showRationale && await shouldShowRationale(permissionType)) {
      // Return a special result indicating rationale should be shown
      return PermissionResult.denied(
        status: ph.PermissionStatus.denied,
      );
    }

    // Request the permission
    return request(permissionType);
  }

  /// Get permission status for UI display
  /// Returns a human-readable string describing the permission status
  String getStatusText(AppPermissionType permissionType, ph.PermissionStatus status) {
    switch (status) {
      case ph.PermissionStatus.granted:
        return '${permissionType.permissionName} access granted';
      case ph.PermissionStatus.denied:
        return '${permissionType.permissionName} access denied';
      case ph.PermissionStatus.permanentlyDenied:
        return '${permissionType.permissionName} access permanently denied';
      case ph.PermissionStatus.restricted:
        return '${permissionType.permissionName} access restricted';
      case ph.PermissionStatus.limited:
        return '${permissionType.permissionName} access limited';
      case ph.PermissionStatus.provisional:
        return '${permissionType.permissionName} access provisional';
    }
  }
}
