/// Permission Handler Widget
///
/// A wrapper widget that handles permission requests with pre-permission UI.
/// Shows explanation dialog before requesting permission and handles denial states.
library;

import 'package:flutter/material.dart';

import '../../core/constants/permission_constants.dart';
import '../../core/services/permission_service.dart';
import 'permission_dialog.dart';

/// Permission request state
enum PermissionState {
  /// Initial state - permission not yet requested
  initial,

  /// Checking permission status
  checking,

  /// Showing pre-permission explanation
  showingRationale,

  /// Requesting permission from system
  requesting,

  /// Permission granted
  granted,

  /// Permission denied (can retry)
  denied,

  /// Permission permanently denied (must go to settings)
  permanentlyDenied,

  /// Error occurred
  error,
}

/// Widget that handles permission requests with pre-permission UI
///
/// Wrap any widget that needs a permission with this widget.
/// It will automatically handle showing explanation dialogs and
/// requesting permissions.
class PermissionHandlerWidget extends StatefulWidget {
  /// The permission type to request
  final AppPermissionType permissionType;

  /// The child widget that requires the permission
  final Widget child;

  /// Widget to show when permission is denied
  final Widget? deniedWidget;

  /// Widget to show when permission is permanently denied
  final Widget? permanentlyDeniedWidget;

  /// Widget to show while checking/requesting
  final Widget? loadingWidget;

  /// Custom pre-permission title
  final String? prePermissionTitle;

  /// Custom pre-permission message
  final String? prePermissionMessage;

  /// Custom permission denied title
  final String? deniedTitle;

  /// Custom permission denied message
  final String? deniedMessage;

  /// Custom permanently denied title
  final String? permanentlyDeniedTitle;

  /// Custom permanently denied message
  final String? permanentlyDeniedMessage;

  /// Whether to show pre-permission rationale dialog
  final bool showPrePermissionDialog;

  /// Callback when permission is granted
  final VoidCallback? onGranted;

  /// Callback when permission is denied
  final VoidCallback? onDenied;

  /// Callback when permission is permanently denied
  final VoidCallback? onPermanentlyDenied;

  /// Callback when user opens settings
  final VoidCallback? onOpenSettings;

  /// Permission service instance (optional, uses default if not provided)
  final PermissionService? permissionService;

  const PermissionHandlerWidget({
    super.key,
    required this.permissionType,
    required this.child,
    this.deniedWidget,
    this.permanentlyDeniedWidget,
    this.loadingWidget,
    this.prePermissionTitle,
    this.prePermissionMessage,
    this.deniedTitle,
    this.deniedMessage,
    this.permanentlyDeniedTitle,
    this.permanentlyDeniedMessage,
    this.showPrePermissionDialog = true,
    this.onGranted,
    this.onDenied,
    this.onPermanentlyDenied,
    this.onOpenSettings,
    this.permissionService,
  });

  @override
  State<PermissionHandlerWidget> createState() => _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  late final PermissionService _permissionService;
  PermissionState _state = PermissionState.initial;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _permissionService = widget.permissionService ?? PermissionService();
    _checkPermission();
  }

  /// Check current permission status
  Future<void> _checkPermission() async {
    setState(() => _state = PermissionState.checking);

    try {
      // Check if already granted
      final isGranted = await _permissionService.isGranted(widget.permissionType);

      if (isGranted) {
        setState(() => _state = PermissionState.granted);
        widget.onGranted?.call();
      } else {
        // Check if permanently denied
        final isPermanentlyDenied = await _permissionService.isPermanentlyDenied(
          widget.permissionType,
        );

        if (isPermanentlyDenied) {
          setState(() => _state = PermissionState.permanentlyDenied);
        } else {
          // Show pre-permission dialog or request directly
          if (widget.showPrePermissionDialog) {
            await _showPrePermissionDialog();
          } else {
            await _requestPermission();
          }
        }
      }
    } catch (e) {
      setState(() {
        _state = PermissionState.error;
        _errorMessage = e.toString();
      });
    }
  }

  /// Show pre-permission explanation dialog
  Future<void> _showPrePermissionDialog() async {
    setState(() => _state = PermissionState.showingRationale);

    final shouldContinue = await PrePermissionDialog.show(
      context: context,
      permissionType: widget.permissionType,
      title: widget.prePermissionTitle,
      message: widget.prePermissionMessage,
    );

    if (shouldContinue) {
      await _requestPermission();
    } else {
      setState(() => _state = PermissionState.denied);
      widget.onDenied?.call();
    }
  }

  /// Request permission from the system
  Future<void> _requestPermission() async {
    setState(() => _state = PermissionState.requesting);

    try {
      final result = await _permissionService.request(widget.permissionType);

      if (result.isGranted) {
        setState(() => _state = PermissionState.granted);
        widget.onGranted?.call();
      } else if (result.isPermanentlyDenied) {
        setState(() => _state = PermissionState.permanentlyDenied);
        widget.onPermanentlyDenied?.call();
      } else {
        setState(() => _state = PermissionState.denied);
        widget.onDenied?.call();
      }
    } catch (e) {
      setState(() {
        _state = PermissionState.error;
        _errorMessage = e.toString();
      });
    }
  }

  /// Open app settings
  Future<void> _openSettings() async {
    await _permissionService.openSettings();
    widget.onOpenSettings?.call();
  }

  /// Retry permission request
  Future<void> retry() async {
    await _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case PermissionState.initial:
      case PermissionState.checking:
      case PermissionState.requesting:
      case PermissionState.showingRationale:
        return widget.loadingWidget ?? _buildDefaultLoading();

      case PermissionState.granted:
        return widget.child;

      case PermissionState.denied:
        return widget.deniedWidget ?? _buildDefaultDeniedWidget();

      case PermissionState.permanentlyDenied:
        return widget.permanentlyDeniedWidget ?? _buildDefaultPermanentlyDeniedWidget();

      case PermissionState.error:
        return _buildErrorWidget();
    }
  }

  /// Build default loading widget
  Widget _buildDefaultLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// Build default denied widget
  Widget _buildDefaultDeniedWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            Text(
              widget.deniedTitle ?? PermissionDialogTexts.permissionDeniedTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.deniedMessage ??
                  PermissionDialogTexts.permissionDeniedMessage.replaceAll(
                    '{permissionName}',
                    widget.permissionType.permissionName,
                  ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: retry,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build default permanently denied widget
  Widget _buildDefaultPermanentlyDeniedWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.settings_outlined,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              widget.permanentlyDeniedTitle ??
                  PermissionDialogTexts.permanentlyDeniedTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.permanentlyDeniedMessage ??
                  PermissionDialogTexts.permanentlyDeniedMessage.replaceAll(
                    '{permissionName}',
                    widget.permissionType.permissionName,
                  ),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openSettings,
              child: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: retry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extension for easier permission handling
extension PermissionHandlerExtension on BuildContext {
  /// Request a permission with pre-permission dialog
  ///
  /// Returns true if permission was granted, false otherwise.
  Future<bool> requestPermission(
    AppPermissionType permissionType, {
    String? title,
    String? message,
  }) async {
    // Show pre-permission dialog
    final shouldContinue = await PrePermissionDialog.show(
      context: this,
      permissionType: permissionType,
      title: title,
      message: message,
    );

    if (!shouldContinue) {
      return false;
    }

    // Request permission
    final permissionService = PermissionService();
    final result = await permissionService.request(permissionType);

    if (result.isGranted) {
      return true;
    }

    if (result.isPermanentlyDenied) {
      // Show permanently denied dialog
      await PermissionPermanentlyDeniedDialog.show(
        context: this,
        permissionType: permissionType,
      );

      // Open settings
      await permissionService.openSettings();
    }

    return false;
  }
}
