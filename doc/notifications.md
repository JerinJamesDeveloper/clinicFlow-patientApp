# Notification Feature Documentation

## Overview

The notification feature provides a complete solution for managing notifications in the EVLOV IGNITE Flutter app. It supports both local notifications and push notifications via Firebase Cloud Messaging (FCM).

## Architecture

### Layers

1. **Domain Layer** - Business logic and entities
2. **Data Layer** - API integration and data models
3. **Core Services** - Local notifications, push notifications, and navigation handling
4. **Presentation Layer** - UI components and BLoC state management

## Components

### 1. Notification Entity

Location: `lib/features/notifications/domain/entities/notification_entity.dart`

The notification entity contains:
- `id` - Unique identifier
- `title` - Notification title
- `body` - Notification body/description
- `type` - Notification type (info, success, warning, error, message, like, comment, follow, system)
- `isRead` - Read status
- `isNew` - New notification status
- `readAt` - Timestamp when read
- `createdAt` - Creation timestamp
- `actionUrl` - Optional URL for deep linking
- `data` - Additional custom data

### 2. Notification Types

```
dart
enum NotificationType {
  info,      // General information
  success,   // Success messages
  warning,   // Warning messages
  error,     // Error messages
  message,   // Chat messages
  like,      // Like notifications
  comment,   // Comment notifications
  follow,    // Follow notifications
  system,    // System notifications
}
```

### 3. Repository Interface

Location: `lib/features/notifications/domain/repositories/notification_repository.dart`

Methods:
- `getNotifications({int page, int limit})` - Get paginated notifications
- `markAsRead(String notificationId)` - Mark notification as read
- `markAllAsRead()` - Mark all notifications as read
- `deleteNotification(String notificationId)` - Delete a notification
- `clearAll()` - Clear all notifications
- `getUnreadCount()` - Get count of unread notifications

## Services

### 1. Local Notification Service

Location: `lib/core/services/local_notification_service.dart`

#### Initialization

```
dart
final localNotificationService = LocalNotificationService();
await localNotificationService.initialize();
```

#### Request Permissions

```
dart
bool granted = await localNotificationService.requestPermissions();
```

#### Show Simple Notification

```
dart
await localNotificationService.showNotification(
  id: 1,
  title: 'Hello',
  body: 'This is a notification',
);
```

#### Show Notification with Data

```
dart
await localNotificationService.showNotificationWithData(
  id: 1,
  title: 'New Message',
  body: 'You have a new message from John',
  data: {
    'navigation_type': 'post',
    'post_id': '123',
  },
);
```

#### Schedule Notification

```
dart
await localNotificationService.scheduleNotification(
  id: 1,
  title: 'Reminder',
  body: 'Don\'t forget your meeting',
  scheduledTime: DateTime.now().add(Duration(hours: 1)),
);
```

#### Cancel Notifications

```
dart
// Cancel specific notification
await localNotificationService.cancelNotification(1);

// Cancel all notifications
await localNotificationService.cancelAllNotifications();
```

### 2. Push Notification Service

Location: `lib/core/services/push_notification_service.dart`

#### Initialization

```
dart
final pushNotificationService = PushNotificationService();

// Initialize with callbacks
await pushNotificationService.initialize(
  onForegroundMessage: (message) {
    // Handle message when app is in foreground
  },
  onBackgroundMessage: (message) {
    // Handle message when app is in background
  },
);
```

#### Get FCM Token

```
dart
String? token = await pushNotificationService.getToken();
```

#### Subscribe to Topics

```
dart
await pushNotificationService.subscribeToTopic('all_users');
await pushNotificationService.subscribeToTopic('premium_users');
```

#### Unsubscribe from Topics

```
dart
await pushNotificationService.unsubscribeFromTopic('all_users');
```

### 3. Notification Handler Service

Location: `lib/core/services/notification_handler_service.dart`

#### Handle Notification Tap

The service handles navigation based on notification data:

```
dart
// In your notification tap handler
NotificationHandlerService.handleNotificationData(data);

// Or from payload string
NotificationHandlerService.handleNotificationTap(payload);
```

#### Supported Navigation Types

| Type | Description | Data Required |
|------|-------------|---------------|
| `home` | Navigate to home | - |
| `notifications` | Navigate to notifications | - |
| `profile` | Navigate to profile | `user_id` (optional) |
| `settings` | Navigate to settings | - |
| `post` | Navigate to post | `post_id` |
| `user` | Navigate to user profile | `user_id` |
| `custom` | Navigate to custom route | `route` |
| `none` | No navigation | - |

#### Example Notification Data

```
json
{
  "notification_id": "123",
  "title": "New Comment",
  "body": "John commented on your post",
  "navigation_type": "post",
  "post_id": "456"
}
```

## Presentation Layer

### BLoC Usage

Location: `lib/features/notifications/presentation/bloc/notification_bloc.dart`

#### Add to Widget Tree

```
dart
BlocProvider(
  create: (context) => getIt<NotificationBloc>(),
  child: const NotificationsPage(),
)
```

#### Events

```dart
// Load notifications
context.read<NotificationBloc>().add(const NotificationLoadRequested());

// Load more (pagination)
context.read<NotificationBloc>().add(const NotificationLoadMoreRequested());

// Mark as read
context.read<NotificationBloc>().add(
  NotificationMarkAsReadRequested(notificationId: '123'),
);

// Delete notification
context.read<NotificationBloc>().add(
  NotificationDeleteRequested(notificationId: '123'),
);

// Mark all as read
context.read<NotificationBloc>().add(const NotificationMarkAllAsReadRequested());

// Clear all
context.read<NotificationBloc>().add(const NotificationClearAllRequested());

// Refresh
context.read<NotificationBloc>().add(const NotificationRefreshRequested());
```

#### States

```
dart
// Initial state
NotificationInitial()

// Loading
NotificationLoading()

// Loaded successfully
NotificationLoaded(
  notifications: [...],
  unreadCount: 5,
  hasMore: true,
  currentPage: 1,
)

// Error
NotificationError(message: 'Error message')

// Operation in progress
NotificationOperationInProgress(
  notifications: [...],
  operation: 'Marking as read...',
)

// Operation success
NotificationOperationSuccess(
  notifications: [...],
  message: 'Notification marked as read',
)
```

## Navigation

### Route

Notifications page is available at: `/notifications`

### Badge Count

To show notification badge in bottom navigation:

```
dart
// Get unread count from BLoC state
final unreadCount = state.unreadCount;

// Pass to NavItem
NavItem(
  route: '/notifications',
  icon: Icons.notifications_outlined,
  activeIcon: Icons.notifications,
  label: 'Notifications',
  badgeCount: unreadCount > 0 ? unreadCount : null,
)
```

## Integration Steps

### 1. Update Dependency Injection

In `lib/core/di/injection_container.dart`:

```
dart
// Register notification services
getIt.registerLazySingleton(() => LocalNotificationService());
getIt.registerLazySingleton(() => PushNotificationService());

// Register repository
getIt.registerLazySingleton<NotificationRepository>(
  () => NotificationRepositoryImpl(
    remoteDataSource: getIt(),
  ),
);

// Register use cases
getIt.registerLazySingleton(() => GetNotificationsUseCase(getIt()));
getIt.registerLazySingleton(() => MarkNotificationReadUseCase(getIt()));
getIt.registerLazySingleton(() => DeleteNotificationUseCase(getIt()));
getIt.registerLazySingleton(() => MarkAllNotificationsReadUseCase(getIt()));
getIt.registerLazySingleton(() => GetUnreadNotificationCountUseCase(getIt()));
getIt.registerLazySingleton(() => ClearAllNotificationsUseCase(getIt()));

// Register BLoC
getIt.registerFactory(() => NotificationBloc(
  getNotificationsUseCase: getIt(),
  markNotificationReadUseCase: getIt(),
  deleteNotificationUseCase: getIt(),
  markAllAsReadUseCase: getIt(),
  getUnreadCountUseCase: getIt(),
  clearAllUseCase: getIt(),
  repository: getIt(),
));
```

### 2. Update Main.dart

```
dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize local notifications
  final localNotificationService = getIt<LocalNotificationService>();
  await localNotificationService.initialize();
  
  // Initialize push notifications
  final pushNotificationService = getIt<PushNotificationService>();
  await pushNotificationService.initialize(
    onForegroundMessage: _handleForegroundMessage,
    onBackgroundMessage: _handleBackgroundMessage,
  );
  
  // Set notification tap callback
  localNotificationService.setNotificationCallback(
    NotificationHandlerService.handleNotificationTap,
  );
  
  runApp(const MyApp());
}

void _handleForegroundMessage(RemoteMessage message) {
  // Show local notification
  final localNotificationService = getIt<LocalNotificationService>();
  localNotificationService.showNotification(
    id: message.notification?.hashCode ?? 0,
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
  );
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _handleBackgroundMessage(RemoteMessage message) async {
  // Handle background message
}
```

### 3. Android Configuration

In `android/app/src/main/AndroidManifest.xml`:

```
xml
<manifest ...>
  <!-- Permissions -->
  <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
  <uses-permission android:name="android.permission.VIBRATE" />
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
  <uses-permission android:name="android.permission.USE_FULL_SCREEN_INTENT" />
  
  <application ...>
    <!-- Notification icon -->
    <meta-data
      android:name="com.google.firebase.messaging.default_notification_icon"
      android:resource="@mipmap/ic_launcher" />
    
    <!-- Notification color -->
    <meta-data
      android:name="com.google.firebase.messaging.default_notification_color"
      android:resource="@color/colorPrimary" />
    
    <!-- Notification channel -->
    <meta-data
      android:name="com.google.firebase.messaging.default_notification_channel_id"
      android:value="evlov_ignite_notifications" />
  </application>
</manifest>
```

### 4. iOS Configuration

In `ios/Runner/Info.plist`:

```
xml
<key>UIBackgroundModes</key>
<array>
  <string>fetch</string>
  <string>remote-notification</string>
</array>
```

In `ios/Runner/AppDelegate.swift`:

```
swift
if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
}
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/notifications` | Get notifications (paginated) |
| GET | `/api/notifications/unread-count` | Get unread count |
| POST | `/api/notifications/:id/read` | Mark as read |
| POST | `/api/notifications/read-all` | Mark all as read |
| DELETE | `/api/notifications/:id` | Delete notification |
| DELETE | `/api/notifications` | Clear all notifications |

## Example Usage

### Show Local Notification

```
dart
final localNotificationService = getIt<LocalNotificationService>();

await localNotificationService.showNotification(
  id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
  title: 'Welcome!',
  body: 'Thanks for using EVLOV IGNITE',
  payload: jsonEncode({
    'navigation_type': 'home',
  }),
);
```

### Handle Push Notification

```
dart
FirebaseMessaging.onMessage.listen((message) {
  final localNotificationService = getIt<LocalNotificationService>();
  
  localNotificationService.showNotification(
    id: message.hashCode,
    title: message.notification?.title ?? '',
    body: message.notification?.body ?? '',
    payload: jsonEncode(message.data),
  );
});
```

### Navigate from Notification

```
dart
// Set up the notification callback
localNotificationService.setNotificationCallback((payload) {
  final data = jsonDecode(payload) as Map<String, dynamic>;
  NotificationHandlerService.handleNotificationData(data);
});
```

## Testing

### Test Local Notifications

```dart
// Test show notification
await localNotificationService.showNotification(
  id: 1,
  title: 'Test Notification',
  body: 'This is a test',
);

// Test scheduled notification
await localNotificationService.scheduleNotification(
  id: 2,
  title: 'Scheduled Notification',
  body: 'This will appear in 1 minute',
  scheduledTime: DateTime.now().add(const Duration(minutes: 1)),
);
```

### Test Push Notifications

Use Firebase Console or Firebase Admin SDK to send test messages:

```
dart
// Example: Send via Firebase Admin SDK (server-side)
admin.messaging().send({
  token: deviceToken,
  notification: {
    title: 'Test Push',
    body: 'This is a push notification test',
  },
  data: {
    'navigation_type': 'post',
    'post_id': '123',
  },
});
