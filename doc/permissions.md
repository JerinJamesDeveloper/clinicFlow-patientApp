# Permission Handling Documentation

**Guide for implementing permission requests with pre-permission UI in the app.**

---

## Overview

The app includes a complete permission handling system that provides:
- Pre-permission explanation dialogs
- Graceful handling of permission denials
- Automatic routing to settings when permissions are permanently denied
- Reusable widgets and services for consistent permission UX

---

## Available Permission Types

| Permission Type | Description | Use Case |
|-----------------|-------------|----------|
| `camera` | Take photos and record videos | Camera features, QR scanning |
| `microphone` | Record audio | Voice messages, video recording |
| `locationWhenInUse` | Show location on map | Maps, nearby features |
| `locationAlways` | Track location | Background tracking |
| `photos` | Access photos and videos | Media gallery, image picker |
| `storage` | Access files on device | File uploads, downloads |
| `contacts` | Access contacts list | Contact picker, social features |
| `calendar` | Access calendar events | Event scheduling |
| `notifications` | Push notifications | Alerts, updates |

---

## Quick Start

### 1. Basic Permission Request

```
dart
import 'package:your_app/core/constants/permission_constants.dart';
import 'package:your_app/core/services/permission_service.dart';

// Check if permission is granted
final permissionService = PermissionService();
final isGranted = await permissionService.isGranted(AppPermissionType.camera);

if (isGranted) {
  // Permission already granted, proceed with feature
} else {
  // Request permission
  final result = await permissionService.request(AppPermissionType.camera);
  
  if (result.isGranted) {
    // Permission granted, proceed with feature
  }
}
```

### 2. Using the PermissionHandlerWidget

Wrap any widget that requires a permission:

```
dart
import 'package:your_app/core/constants/permission_constants.dart';
import 'package:your_app/shared/widgets/permission_handler_widget.dart';

PermissionHandlerWidget(
  permissionType: AppPermissionType.camera,
  child: CameraPreview(),
  onGranted: () {
    print('Camera permission granted!');
  },
  onDenied: () {
    print('Camera permission denied');
  },
  onPermanentlyDenied: () {
    print('Go to settings to enable camera');
  },
)
```

---

## Use Case Examples

### Use Case 1: Camera Feature

```
dart
class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take Photo')),
      body: PermissionHandlerWidget(
        permissionType: AppPermissionType.camera,
        child: CameraWidget(),
        loadingWidget: Center(child: CircularProgressIndicator()),
        deniedWidget: _buildDeniedWidget(context),
        permanentlyDeniedWidget: _buildSettingsWidget(context),
      ),
    );
  }

  Widget _buildDeniedWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 64),
          Text('Camera permission required'),
          ElevatedButton(
            onPressed: () => context.read<PermissionHandlerWidget>().retry(),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.settings_outlined, size: 64),
          Text('Enable camera in settings'),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            child: Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
```

### Use Case 2: Location-Based Feature

```
dart
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nearby Places')),
      body: PermissionHandlerWidget(
        permissionType: AppPermissionType.locationWhenInUse,
        prePermissionTitle: 'Location Access Needed',
        prePermissionMessage: 'We need your location to show nearby places on the map.',
        child: MapWidget(),
        onGranted: () {
          // Start location tracking
        },
      ),
    );
  }
}
```

### Use Case 3: Photo Gallery

```
dart
class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Photos')),
      body: PermissionHandlerWidget(
        permissionType: AppPermissionType.photos,
        child: PhotoGrid(),
      ),
    );
  }
}
```

### Use Case 4: Voice Recording

```
dart
class VoiceRecorderPage extends StatelessWidget {
  const VoiceRecorderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Recorder')),
      body: PermissionHandlerWidget(
        permissionType: AppPermissionType.microphone,
        prePermissionTitle: 'Microphone Access',
        prePermissionMessage: 'We need microphone access to record audio messages.',
        child: RecorderWidget(),
      ),
    );
  }
}
```

---

## Using the BuildContext Extension

For quick permission requests without the widget:

```
dart
import 'package:your_app/shared/widgets/permission_handler_widget.dart';
import 'package:your_app/core/constants/permission_constants.dart';

// In a StatefulWidget or using a BuildContext
final hasPermission = await context.requestPermission(
  AppPermissionType.camera,
  title: 'Camera Access',
  message: 'We need camera access to take photos for your profile.',
);

if (hasPermission) {
  // Open camera
}
```

---

## Dialog Customization

### Custom Pre-Permission Dialog

```
dart
PrePermissionDialog.show(
  context: context,
  permissionType: AppPermissionType.locationWhenInUse,
  title: 'Location Access',
  message: 'We need your location to find nearby restaurants.',
  continueButtonText: 'Allow',
  cancelButtonText: 'Not Now',
);
```

### Custom Denied Dialog

```
dart
PermissionDeniedDialog.show(
  context: context,
  permissionType: AppPermissionType.camera,
  title: 'Camera Required',
  message: 'Please enable camera access in settings.',
  settingsButtonText: 'Open Settings',
);
```

---

## Platform Configuration

### iOS (Info.plist)

Add to `ios/Runner/Info.plist`:

```
xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to take photos</string>
<key>NSMicrophoneUsageDescription</key>
<string>We need microphone access to record audio</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location to show nearby places</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>We need access to your photos</string>
<key>NSContactsUsageDescription</key>
<string>We need access to your contacts</string>
<key>NSCalendarsUsageDescription</key>
<string>We need access to your calendar</string>
```

### Android (AndroidManifest.xml)

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_CONTACTS"/>
<uses-permission android:name="android.permission.READ_CALENDAR"/>
```

---

## PermissionService API Reference

### Methods

| Method | Description | Returns |
|--------|-------------|---------|
| `isGranted(permissionType)` | Check if permission is granted | `Future<bool>` |
| `getStatus(permissionType)` | Get current permission status | `Future<PermissionStatus>` |
| `request(permissionType)` | Request permission | `Future<PermissionResult>` |
| `requestMultiple(types)` | Request multiple permissions | `Future<Map<PermissionType, PermissionResult>>` |
| `isPermanentlyDenied(type)` | Check if permanently denied | `Future<bool>` |
| `shouldShowRationale(type)` | Check if rationale should show | `Future<bool>` |
| `openSettings()` | Open app settings | `Future<bool>` |

### PermissionResult

| Property | Type | Description |
|----------|------|-------------|
| `isGranted` | `bool` | Whether permission was granted |
| `isPermanentlyDenied` | `bool` | Whether permanently denied |
| `status` | `PermissionStatus` | Current status |
| `errorMessage` | `String?` | Error message if any |

---

## Best Practices

1. **Always show pre-permission dialogs**: Explain why you need the permission before requesting
2. **Handle all states**: Always handle granted, denied, and permanently denied states
3. **Provide fallback UI**: Show alternative UI when permission is denied
4. **Use descriptive messages**: Clear explanations improve user trust
5. **Test on real devices**: Permission behavior varies between devices and OS versions

---

## Troubleshooting

### Permission still denied after enabling

- Check if the app was killed after permission change
- Verify the permission is correctly added to Info.plist/AndroidManifest.xml
- Some permissions require app restart

### Dialog not showing

- Ensure you're using a valid `BuildContext`
- Check if another dialog is already shown

### Widget not rebuilding

- Make sure to call `setState()` in callbacks
- Check if `PermissionHandlerWidget` is properly placed in widget tree

---

For more details, see the source code:
- `lib/core/services/permission_service.dart`
- `lib/core/constants/permission_constants.dart`
- `lib/shared/widgets/permission_dialog.dart`
- `lib/shared/widgets/permission_handler_widget.dart`
