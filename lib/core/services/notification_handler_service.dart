/// Notification Handler Service
///
/// Service for handling notification events and navigation.
library;

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/notifications/domain/entities/notification_entity.dart';

/// Navigation types for notifications
enum NotificationNavigationType {
  /// Navigate to home
  home,
  
  /// Navigate to notifications list
  notifications,
  
  /// Navigate to profile
  profile,
  
  /// Navigate to settings
  settings,
  
  /// Navigate to specific post
  post,
  
  /// Navigate to specific user profile
  user,
  
  /// Navigate to custom URL
  custom,
  
  /// No navigation (just open app)
  none,
}

/// Parse navigation type from string
NotificationNavigationType _parseNavigationType(String? type) {
  switch (type) {
    case 'home':
      return NotificationNavigationType.home;
    case 'notifications':
      return NotificationNavigationType.notifications;
    case 'profile':
      return NotificationNavigationType.profile;
    case 'settings':
      return NotificationNavigationType.settings;
    case 'post':
      return NotificationNavigationType.post;
    case 'user':
      return NotificationNavigationType.user;
    case 'custom':
      return NotificationNavigationType.custom;
    case 'none':
      return NotificationNavigationType.none;
    default:
      return NotificationNavigationType.none;
  }
}

/// Service for handling notification events and navigation
class NotificationHandlerService {
  /// Global key for navigator state
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Handle notification data and navigate accordingly
  static void handleNotificationData(Map<String, dynamic> data) {
    final navigationType = _parseNavigationType(data['navigation_type'] as String?);
    final route = data['route'] as String?;
    final notificationId = data['notification_id'] as String?;
    final notificationType = data['type'] as String?;

    if (kDebugMode) {
      print('Handling notification: type=$notificationType, navigation=$navigationType, route=$route');
    }

    // Handle based on navigation type
    switch (navigationType) {
      case NotificationNavigationType.home:
        _navigateToHome();
        break;
      case NotificationNavigationType.notifications:
        _navigateToNotifications();
        break;
      case NotificationNavigationType.profile:
        final userId = data['user_id'] as String?;
        _navigateToProfile(userId);
        break;
      case NotificationNavigationType.settings:
        _navigateToSettings();
        break;
      case NotificationNavigationType.post:
        final postId = data['post_id'] as String?;
        _navigateToPost(postId);
        break;
      case NotificationNavigationType.user:
        final userId = data['user_id'] as String?;
        _navigateToUser(userId);
        break;
      case NotificationNavigationType.custom:
        if (route != null) {
          _navigateToCustomRoute(route);
        }
        break;
      case NotificationNavigationType.none:
        // Just open the app, don't navigate
        break;
    }
  }

  /// Handle notification tap from payload string
  static void handleNotificationTap(String payload) {
    try {
      final data = jsonDecode(payload) as Map<String, dynamic>;
      handleNotificationData(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing notification payload: $e');
      }
      // Navigate to home on error
      _navigateToHome();
    }
  }

  /// Navigate to home
  static void _navigateToHome() {
    _navigateToRoute('/home');
  }

  /// Navigate to notifications
  static void _navigateToNotifications() {
    _navigateToRoute('/notifications');
  }

  /// Navigate to profile
  static void _navigateToProfile(String? userId) {
    if (userId != null) {
      _navigateToRoute('/profile/$userId');
    } else {
      _navigateToRoute('/profile');
    }
  }

  /// Navigate to settings
  static void _navigateToSettings() {
    _navigateToRoute('/settings');
  }

  /// Navigate to post
  static void _navigateToPost(String? postId) {
    if (postId != null) {
      _navigateToRoute('/post/$postId');
    } else {
      _navigateToHome();
    }
  }

  /// Navigate to user
  static void _navigateToUser(String? userId) {
    if (userId != null) {
      _navigateToRoute('/user/$userId');
    } else {
      _navigateToHome();
    }
  }

  /// Navigate to custom route
  static void _navigateToCustomRoute(String route) {
    _navigateToRoute(route);
  }

  /// Navigate to route using GoRouter
  static void _navigateToRoute(String route) {
    try {
      final context = navigatorKey.currentContext;
      if (context != null) {
        context.go(route);
      } else {
        if (kDebugMode) {
          print('Navigation context is null, cannot navigate to $route');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error navigating to $route: $e');
      }
    }
  }

  /// Create notification data from entity
  static Map<String, dynamic> createNotificationData(NotificationEntity entity) {
    return {
      'notification_id': entity.id,
      'type': entity.type.name,
      'title': entity.title,
      'body': entity.body,
      'navigation_type': _getNavigationTypeFromData(entity.data),
      'route': entity.actionUrl,
      ...?entity.data,
    };
  }

  /// Get navigation type from notification data
  static String _getNavigationTypeFromData(Map<String, dynamic>? data) {
    if (data == null) return 'none';
    
    if (data.containsKey('post_id')) return 'post';
    if (data.containsKey('user_id')) return 'user';
    if (data.containsKey('route')) return 'custom';
    
    return 'none';
  }

  /// Extract notification type from data
  static NotificationType? getNotificationType(Map<String, dynamic> data) {
    final typeStr = data['notification_type'] as String?;
    if (typeStr == null) return null;

    switch (typeStr) {
      case 'info':
        return NotificationType.info;
      case 'success':
        return NotificationType.success;
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      case 'message':
        return NotificationType.message;
      case 'like':
        return NotificationType.like;
      case 'comment':
        return NotificationType.comment;
      case 'follow':
        return NotificationType.follow;
      case 'system':
        return NotificationType.system;
      default:
        return null;
    }
  }
}
