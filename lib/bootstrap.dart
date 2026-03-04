/// Bootstrap
/// 
/// Application initialization and configuration.
/// Handles all setup before running the app.
library;

import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_bloc_observer.dart';
import 'core/di/injection_container.dart';

/// Bootstrap the application
/// 
/// This function:
/// 1. Ensures Flutter bindings are initialized
/// 2. Sets up error handling
/// 3. Initializes dependencies
/// 4. Configures system UI
/// 5. Sets up BLoC observer
/// 
/// Usage in main.dart:
/// ```dart
/// void main() async {
///   await bootstrap(() => const App());
/// }
/// ```
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // Catch Flutter errors
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
    
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  };

  // Catch async errors
  await runZonedGuarded(
    () async {
      // Ensure Flutter bindings are initialized
      WidgetsFlutterBinding.ensureInitialized();

      // Set up BLoC observer for debugging
      Bloc.observer = AppBlocObserver();

      // Initialize dependencies
      await _initializeApp();

      // Run the app
      runApp(await builder());
    },
    (error, stackTrace) {
      log('Uncaught error: $error', stackTrace: stackTrace);
      
      if (kDebugMode) {
        // In debug mode, rethrow to see the error
        throw error;
      }
    },
  );
}

/// Initialize application dependencies and configuration
Future<void> _initializeApp() async {
  // Initialize dependency injection
  await initDependencies();

  // Configure system UI
  await _configureSystemUI();

  // Additional initialization can be added here:
  // - Firebase
  // - Analytics
  // - Crash reporting
  // - etc.
}

/// Configure system UI (status bar, navigation bar)
Future<void> _configureSystemUI() async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Enable edge-to-edge mode on Android
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );
}

/// Update system UI for dark mode
void updateSystemUIForDarkMode(bool isDark) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ),
  );
}