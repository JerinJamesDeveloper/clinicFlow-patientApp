/// Push Notification Service
///
/// Service for managing Firebase Cloud Messaging (FCM) push notifications.
library;

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'local_notification_service.dart';

/// Callback type for when a notification is received in foreground
typedef OnForegroundMessage = void Function(Map<String, dynamic> data);

/// Callback type for when a notification is tapped
typedef OnNotificationTap = void Function(Map<String, dynamic> data);

/// Service for managing push notifications via Firebase Cloud Messaging
class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final LocalNotificationService _localNotificationService;
  
  /// Callback for foreground messages
  OnForegroundMessage? _onForegroundMessage;
  
  /// Callback for notification tap
  OnNotificationTap? _onNotificationTap;
  
  /// Whether the service is initialized
  bool _isInitialized = false;
  
  /// Device token
  String? _deviceToken;

  PushNotificationService({
    FirebaseMessaging? firebaseMessaging,
    required LocalNotificationService localNotificationService,
  })  : _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance,
        _localNotificationService = localNotificationService;

  /// Get the device token
  String? get deviceToken => _deviceToken;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

  /// Initialize the push notification service
  Future<void> initialize({
    OnForegroundMessage? onForegroundMessage,
    OnNotificationTap? onNotificationTap,
  }) async {
    if (_isInitialized) return;

    _onForegroundMessage = onForegroundMessage;
    _onNotificationTap = onNotificationTap;

    // Request permission
    await _requestPermission();

    // Get device token
    await _getDeviceToken();

    // Set up foreground message handler
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Set up background message handler
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);

    // Handle notification when app is opened from notification
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);

    // Handle notification when app is in background/killed
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOnMessageOpenedApp);

    // Set up local notification tap callback
    _localNotificationService.setNotificationCallback(_handleLocalNotificationTap);

    _isInitialized = true;
  }

  /// Request notification permissions
  Future<bool> _requestPermission() async {
    try {
      // For iOS/macOS
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      if (kDebugMode) {
        print('Push notification permission status: ${settings.authorizationStatus}');
      }
      
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting push notification permission: $e');
      }
      return false;
    }
  }

  /// Get device token
  Future<void> _getDeviceToken() async {
    try {
      // Check if token is already available
      _deviceToken = await _firebaseMessaging.getToken();
      
      if (kDebugMode) {
        print('FCM Device Token: $_deviceToken');
      }
      
      // Subscribe to topic for general notifications
      await subscribeToTopic('all_users');
    } catch (e) {
      if (kDebugMode) {
        print('Error getting device token: $e');
      }
    }
  }

  /// Refresh device token
  Future<String?> refreshToken() async {
    try {
      _deviceToken = await _firebaseMessaging.getToken();
      if (kDebugMode) {
        print('Refreshed FCM Device Token: $_deviceToken');
      }
      return _deviceToken;
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing device token: $e');
      }
      return null;
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    final data = message.data;
    
    if (kDebugMode) {
      print('Foreground message received: $data');
    }

    // Show local notification
    _showLocalNotificationFromRemoteMessage(message);

    // Call foreground callback
    _onForegroundMessage?.call(data);
  }

  /// Handle background messages
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print('Background message received: ${message.data}');
    }

    // Show local notification from background
    await _showLocalNotificationFromRemoteMessageStatic(message);
  }

  /// Show local notification from remote message
  static Future<void> _showLocalNotificationFromRemoteMessageStatic(
    RemoteMessage message,
  ) async {
    // In production, you would get the service from get_it
    // For now, we'll handle this via the foreground handler
  }

  /// Show local notification from remote message
  Future<void> _showLocalNotificationFromRemoteMessage(
    RemoteMessage message,
  ) async {
    final notification = message.notification;
    if (notification == null) return;

    final data = message.data;
    final payload = jsonEncode(data);

    // Determine notification ID from data or use hash
    final id = data['notification_id'] != null
        ? int.tryParse(data['notification_id'].toString()) ?? message.hashCode
        : message.hashCode;

    await _localNotificationService.showNotification(
      id: id,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: payload,
    );
  }

  /// Handle initial message (when app is opened from killed state)
  void _handleInitialMessage(RemoteMessage? message) {
    if (message == null) return;
    
    final data = message.data;
    
    if (kDebugMode) {
      print('Initial message received: $data');
    }
    
    _onNotificationTap?.call(data);
  }

  /// Handle message when app is opened from background
  void _handleOnMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    
    if (kDebugMode) {
      print('On message opened app: $data');
    }
    
    _onNotificationTap?.call(data);
  }

  /// Handle local notification tap
  void _handleLocalNotificationTap(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      _onNotificationTap?.call(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing notification payload: $e');
      }
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error subscribing to topic: $e');
      }
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error unsubscribing from topic: $e');
      }
    }
  }

  /// Get notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }

  /// Delete the device token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _deviceToken = null;
      if (kDebugMode) {
        print('Device token deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting device token: $e');
      }
    }
  }

  /// Check if token is available
  bool get hasToken => _deviceToken != null && _deviceToken!.isNotEmpty;
}
