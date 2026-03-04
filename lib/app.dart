/// App Widget
/// 
/// Root widget of the application.
/// Sets up MaterialApp with routing, theming, and BLoC providers.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'navigation/app_router.dart';

/// Root application widget
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;
  late final AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _appRouter = AppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Auth BLoC - global, single instance
        BlocProvider<AuthBloc>.value(
          value: _authBloc,
        ),
        // Profile BLoC - can be created per-screen or global
        BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>(),
        ),
      ],
      child: MaterialApp.router(
        // App Info
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Routing
        routerConfig: _appRouter.router,

        // Theming
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Localization (can be expanded later)
        // localizationsDelegates: const [...],
        // supportedLocales: const [...],

        // Builder for global overlays/wrappers
        builder: (context, child) {
          return _AppWrapper(child: child);
        },
      ),
    );
  }
}

/// App wrapper for global overlays and configurations
class _AppWrapper extends StatelessWidget {
  final Widget? child;

  const _AppWrapper({this.child});

  @override
  Widget build(BuildContext context) {
    // Apply global text scaling limits
    final mediaQuery = MediaQuery.of(context);
    final constrainedTextScaler = mediaQuery.textScaler.clamp(
      minScaleFactor: 0.8,
      maxScaleFactor: 1.4,
    );

    return MediaQuery(
      data: mediaQuery.copyWith(textScaler: constrainedTextScaler),
      child: child ?? const SizedBox.shrink(),
    );
  }
}

/// App with custom configuration
class ConfigurableApp extends StatefulWidget {
  /// Initial theme mode
  final ThemeMode initialThemeMode;
  
  /// Initial locale
  final Locale? initialLocale;
  
  /// Whether to show debug banner
  final bool showDebugBanner;

  const ConfigurableApp({
    super.key,
    this.initialThemeMode = ThemeMode.system,
    this.initialLocale,
    this.showDebugBanner = false,
  });

  @override
  State<ConfigurableApp> createState() => _ConfigurableAppState();
}

class _ConfigurableAppState extends State<ConfigurableApp> {
  late final AppRouter _appRouter;
  late final AuthBloc _authBloc;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>();
    _appRouter = AppRouter(_authBloc);
    _themeMode = widget.initialThemeMode;
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  void _updateThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
      ],
      child: ThemeModeProvider(
        themeMode: _themeMode,
        updateThemeMode: _updateThemeMode,
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              title: AppConstants.appName,
              debugShowCheckedModeBanner: widget.showDebugBanner,
              routerConfig: _appRouter.router,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _themeMode,
              locale: widget.initialLocale,
              builder: (context, child) {
                return _AppWrapper(child: child);
              },
            );
          },
        ),
      ),
    );
  }
}

/// Provider for theme mode updates
class ThemeModeProvider extends InheritedWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> updateThemeMode;

  const ThemeModeProvider({
    super.key,
    required this.themeMode,
    required this.updateThemeMode,
    required super.child,
  });

  static ThemeModeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeModeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeModeProvider oldWidget) {
    return themeMode != oldWidget.themeMode;
  }
}

/// Extension for easy theme mode access
extension ThemeModeExtension on BuildContext {
  /// Get current theme mode
  ThemeMode get themeMode => ThemeModeProvider.of(this)?.themeMode ?? ThemeMode.system;

  /// Update theme mode
  void setThemeMode(ThemeMode mode) {
    ThemeModeProvider.of(this)?.updateThemeMode(mode);
  }

  /// Toggle between light and dark mode
  void toggleThemeMode() {
    final current = themeMode;
    final next = current == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    setThemeMode(next);
  }
}