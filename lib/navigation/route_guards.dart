/// Route Guards
///
/// Guards that protect routes based on authentication and authorization.
/// Used with go_router's redirect functionality.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/domain/entities/user_entity.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import 'role_based_navigator.dart';
import 'route_names.dart';

/// Route guard utilities
class RouteGuards {
  RouteGuards._();

  /// Routes that don't require authentication
  static const List<String> publicRoutes = [
    RoutePaths.splash,
    RoutePaths.login,
    RoutePaths.register,
    RoutePaths.forgotPassword,
    RoutePaths.resetPassword,
    RoutePaths.verifyEmail,
    RoutePaths.verifyOtp,
  ];

  /// Routes that require admin role
  static const List<String> adminRoutes = [
    RoutePaths.adminHome,
    RoutePaths.adminDashboard,
    RoutePaths.adminUsers,
    RoutePaths.adminSettings,
  ];

  /// Check if route is public
  static bool isPublicRoute(String path) {
    return publicRoutes.any((route) {
      if (route == '/') {
        // Root path must be an exact match
        return path == '/';
      }
      // Other routes like /login can use startsWith or exact match
      return path.startsWith(route);
    });
  }

  /// Check if route requires admin
  static bool isAdminRoute(String path) {
    return path.startsWith('/admin');
  }

  /// Main redirect logic for go_router
  static String? redirect(BuildContext context, String location) {
    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;

    // Still loading - don't redirect
    if (state is AuthInitial || state is AuthLoading) {
      return null;
    }

    final isAuthenticated = state is AuthAuthenticated;
    final isPublic = isPublicRoute(location);

    // Not authenticated and trying to access protected route
    if (!isAuthenticated && !isPublic) {
      return RoutePaths.login;
    }

    // Authenticated and trying to access auth pages
    if (isAuthenticated && isPublic && location != RoutePaths.splash) {
      final user = (state as AuthAuthenticated).user;
      return RoleBasedNavigator.getInitialRoute(user.role);
    }

    // Authenticated but trying to access admin route without permission
    if (isAuthenticated && isAdminRoute(location)) {
      final user = (state as AuthAuthenticated).user;
      if (!user.isAdmin) {
        return RoutePaths.accessDenied;
      }
    }

    return null;
  }

  /// Async redirect for more complex checks
  static Future<String?> redirectAsync(
    BuildContext context,
    String location,
  ) async {
    // Can add async checks here (e.g., verify token with server)
    return redirect(context, location);
  }
}

/// Listenable for auth state changes (for go_router refresh)
class AuthStateListenable extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  AuthStateListenable(AuthBloc authBloc) {
    _subscription = authBloc.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Guard widget that wraps pages requiring specific permissions
class RoutePermissionGuard extends StatelessWidget {
  /// Required permissions to access this route
  final List<String> requiredPermissions;

  /// Whether all permissions are required (true) or any (false)
  final bool requireAll;

  /// Child page to show if authorized
  final Widget child;

  /// Page to show if unauthorized
  final Widget? unauthorizedPage;

  const RoutePermissionGuard({
    super.key,
    required this.requiredPermissions,
    required this.child,
    this.requireAll = true,
    this.unauthorizedPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return unauthorizedPage ?? const _AccessDeniedView();
        }

        final user = state.user;
        final hasAccess = requireAll
            ? user.hasAllPermissions(requiredPermissions)
            : user.hasAnyPermission(requiredPermissions);

        if (!hasAccess) {
          return unauthorizedPage ?? const _AccessDeniedView();
        }

        return child;
      },
    );
  }
}

/// Guard widget that wraps pages requiring specific roles
class RouteRoleGuard extends StatelessWidget {
  /// Required roles to access this route
  final List<UserRole> allowedRoles;

  /// Child page to show if authorized
  final Widget child;

  /// Page to show if unauthorized
  final Widget? unauthorizedPage;

  const RouteRoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.unauthorizedPage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return unauthorizedPage ?? const _AccessDeniedView();
        }

        if (!allowedRoles.contains(state.user.role)) {
          return unauthorizedPage ?? const _AccessDeniedView();
        }

        return child;
      },
    );
  }
}

/// Default access denied view
class _AccessDeniedView extends StatelessWidget {
  const _AccessDeniedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 24),
            Text(
              'Access Denied',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'You don\'t have permission to access this page.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Access denied page (full page)
class AccessDeniedPage extends StatelessWidget {
  /// Custom message to display
  final String? message;

  /// Custom action button text
  final String? actionText;

  /// Custom action callback
  final VoidCallback? onAction;

  const AccessDeniedPage({
    super.key,
    this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Denied'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.no_accounts_rounded,
                  size: 64,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Access Denied',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message ??
                    'Sorry, you don\'t have the required permissions to access this page.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed:
                      onAction ??
                      () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is AuthAuthenticated) {
                          final homeRoute = RoleBasedNavigator.getHomeRoute(
                            authState.user.role,
                          );
                          Navigator.of(context).pushReplacementNamed(homeRoute);
                        } else {
                          Navigator.of(context).pushReplacementNamed('/login');
                        }
                      },
                  child: Text(actionText ?? 'Go to Home'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Not found page (404)
class NotFoundPage extends StatelessWidget {
  /// The path that was not found
  final String? path;

  const NotFoundPage({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '404',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Page Not Found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                path != null
                    ? 'The page "$path" could not be found.'
                    : 'The page you\'re looking for doesn\'t exist.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
