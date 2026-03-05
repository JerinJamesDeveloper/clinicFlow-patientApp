/// App Router
///
/// Main routing configuration using go_router.
/// Handles navigation, deep linking, and route guards.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/domain/entities/user_entity.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/pages/otp_verification_page.dart';
import '../features/auth/presentation/pages/splash_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/notifications/presentation/presentation.dart';
import 'role_based_navigator.dart';
import 'route_guards.dart';
import 'route_names.dart';
import 'package:patient_app/features/appointments/presentation/pages/appointments_page.dart';
import 'package:patient_app/features/appointments/presentation/pages/appointments_detail_page.dart';

/// Global navigator key
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Shell navigator key for bottom nav
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Creates and configures the app router
class AppRouter {
  final AuthBloc _authBloc;
  late final GoRouter _router;

  AppRouter(this._authBloc) {
    _router = _createRouter();
  }

  /// Get the router instance
  GoRouter get router => _router;

  /// Create the router configuration
  GoRouter _createRouter() {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: RoutePaths.splash,
      debugLogDiagnostics: true,
      refreshListenable: AuthStateListenable(_authBloc),
      redirect: _handleRedirect,
      errorBuilder: _errorBuilder,
      routes: [
        // ============== AUTH ROUTES ==============
        GoRoute(
          path: RoutePaths.splash,
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutePaths.register,
          name: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RoutePaths.forgotPassword,
          name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: RoutePaths.resetPassword,
          name: RouteNames.resetPassword,
          builder: (context, state) {
            final token = state.uri.queryParameters['token'] ?? '';
            return ResetPasswordPage(token: token);
          },
        ),
        GoRoute(
          path: RoutePaths.verifyOtp,
          name: RouteNames.verifyOtp,
          builder: (context, state) {
            final email = state.uri.queryParameters['email'] ?? '';
            return OtpVerificationPage(email: email);
          },
        ),

        // ============== MAIN APP ROUTES (with Shell) ==============
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) {
            return MainShell(child: child);
          },
          routes: [
            // User Home
            GoRoute(
              path: RoutePaths.home,
              name: RouteNames.home,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const HomePage()),
            ),
            // // Notifications
            // GoRoute(
            //   path: RoutePaths.notifications,
            //   name: RouteNames.notifications,
            //   pageBuilder: (context, state) => const NoTransitionPage(
            //     child: NotificationsPage(),
            //   ),
            // ),
            // Profile
            GoRoute(
              path: RoutePaths.profile,
              name: RouteNames.profile,
              pageBuilder: (context, state) => NoTransitionPage(
                child: _buildPlaceholderPage('Profile', Icons.person),
                // child: const ProfilePage(),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: RouteNames.editProfile,
                  builder: (context, state) =>
                      _buildPlaceholderPage('Edit Profile', Icons.edit),
                ),
              ],
            ),
            // Settings
            GoRoute(
              path: RoutePaths.settings,
              name: RouteNames.settings,
              builder: (context, state) =>
                  _buildPlaceholderPage('Settings', Icons.settings),
              routes: [
                GoRoute(
                  path: 'change-password',
                  name: RouteNames.changePassword,
                  builder: (context, state) =>
                      _buildPlaceholderPage('Change Password', Icons.lock),
                ),
              ],
            ),
            // Appointments
            GoRoute(
              path: RoutePaths.appointments,
              name: RouteNames.appointments,
              pageBuilder: (context, state) =>
                  NoTransitionPage(child: const AppointmentsPage()),
              routes: [
                GoRoute(
                  path: ':appointmentsId',
                  name: RouteNames.appointmentsDetail,
                  builder: (context, state) {
                    final appointmentsId =
                        state.pathParameters['appointmentsId'] ?? '';
                    return AppointmentsDetailPage(id: appointmentsId);
                  },
                ),
              ],
            ),
          ],
        ),

        // ============== ADMIN ROUTES (with Shell) ==============
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) {
            return AdminShell(child: child);
          },
          routes: [
            // Admin Home
            GoRoute(
              path: RoutePaths.adminHome,
              name: RouteNames.adminHome,
              pageBuilder: (context, state) => NoTransitionPage(
                // child: const AdminHomePage(),
                child: _buildPlaceholderPage('admin dash', Icons.dashboard),
              ),
            ),
            // Admin Dashboard
            GoRoute(
              path: RoutePaths.adminDashboard,
              name: RouteNames.adminDashboard,
              pageBuilder: (context, state) => NoTransitionPage(
                child: _buildPlaceholderPage('Dashboard', Icons.dashboard),
              ),
            ),
            // Admin Users
            GoRoute(
              path: RoutePaths.adminUsers,
              name: RouteNames.adminUsers,
              pageBuilder: (context, state) => NoTransitionPage(
                child: _buildPlaceholderPage('Users', Icons.people),
              ),
              routes: [
                GoRoute(
                  path: ':userId',
                  name: RouteNames.adminUserDetail,
                  builder: (context, state) {
                    final userId = state.pathParameters['userId'] ?? '';
                    return _buildPlaceholderPage('User: $userId', Icons.person);
                  },
                ),
              ],
            ),
            // Admin Settings
            GoRoute(
              path: RoutePaths.adminSettings,
              name: RouteNames.adminSettings,
              pageBuilder: (context, state) => NoTransitionPage(
                child: _buildPlaceholderPage('Admin Settings', Icons.settings),
              ),
            ),
          ],
        ),

        // ============== ERROR ROUTES ==============
        GoRoute(
          path: RoutePaths.accessDenied,
          name: RouteNames.accessDenied,
          builder: (context, state) => const AccessDeniedPage(),
        ),
        GoRoute(
          path: RoutePaths.notFound,
          name: RouteNames.notFound,
          builder: (context, state) =>
              NotFoundPage(path: state.uri.queryParameters['path']),
        ),
      ],
    );
  }

  /// Handle route redirects
  String? _handleRedirect(BuildContext context, GoRouterState state) {
    final authState = _authBloc.state;
    final location = state.matchedLocation;

    // Still initializing
    if (authState is AuthInitial) {
      return location == RoutePaths.splash ? null : RoutePaths.splash;
    }

    // Loading state or verification success state - stay on current page
    if (authState is AuthLoading ||
        authState is AuthOperationInProgress ||
        authState is AuthOtpVerificationSuccess) {
      return null;
    }

    final isAuthenticated = authState is AuthAuthenticated;
    final isOnAuthPage = RouteGuards.isPublicRoute(location);

    // Not authenticated
    if (!isAuthenticated) {
      // Allow access to public routes
      if (isOnAuthPage) return null;
      // Redirect to login for protected routes
      return RoutePaths.login;
    }

    // Authenticated
    final user = (authState as AuthAuthenticated).user;

    // On splash, redirect to appropriate home
    if (location == RoutePaths.splash) {
      if (!user.isEmailVerified) {
        return '${RoutePaths.verifyOtp}?email=${Uri.encodeComponent(user.email)}';
      }
      return RoleBasedNavigator.getInitialRoute(user.role);
    }

    // On auth pages, redirect to home (unless it's verifyOtp and user is not verified)
    if (isOnAuthPage) {
      if (!user.isEmailVerified && location == RoutePaths.verifyOtp) {
        return null;
      }
      // If verified, go to the appropriate home route
      if (user.isEmailVerified) {
        return RoleBasedNavigator.getInitialRoute(user.role);
      }
      // Unverified user on a public page (not verifyOtp) → send to OTP
      return '${RoutePaths.verifyOtp}?email=${Uri.encodeComponent(user.email)}';
    }

    // If authenticated but not verified AND currently on the verifyOtp page, stay there.
    // Do NOT re-apply the unverified guard for users already inside the app shell —
    // the user object may be momentarily stale right after OTP success, which would
    // cause a redirect loop back to /verify-otp.
    // The guard only applies when navigating FROM a public route (handled above).

    // Trying to access admin routes without being admin
    if (RouteGuards.isAdminRoute(location) && !user.isAdmin) {
      return RoutePaths.accessDenied;
    }

    // User trying to access admin home should go to user home
    if (location == RoutePaths.adminHome && !user.isAdmin) {
      return RoutePaths.home;
    }

    // Admin on user home should go to admin home
    if (location == RoutePaths.home && user.isAdmin) {
      return RoutePaths.adminHome;
    }

    return null;
  }

  /// Build error page
  Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return NotFoundPage(path: state.uri.path);
  }

  /// Placeholder page builder (for development)
  Widget _buildPlaceholderPage(String title, IconData icon) {
    return _PlaceholderPage(title: title, icon: icon);
  }
}

/// Placeholder page widget
class _PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderPage({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'This page will be implemented in the next phase',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

/// Reset Password Page (minimal implementation)
class ResetPasswordPage extends StatelessWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'Reset Password',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                token.isNotEmpty
                    ? 'Token: ${token.substring(0, 10)}...'
                    : 'No token',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 24),
              const Text('Password reset form will be here'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Main app shell with bottom navigation (for regular users)
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return child;
        }

        final navItems = state.user.bottomNavItems;
        final currentIndex = _calculateSelectedIndex(context, navItems);

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              _onItemTapped(context, index, navItems);
            },
            destinations: navItems.map((item) {
              return NavigationDestination(
                icon: Badge(
                  isLabelVisible: (item.badgeCount ?? 0) > 0,
                  label: Text('${item.badgeCount}'),
                  child: Icon(item.icon),
                ),
                selectedIcon: Badge(
                  isLabelVisible: (item.badgeCount ?? 0) > 0,
                  label: Text('${item.badgeCount}'),
                  child: Icon(item.activeIcon ?? item.icon),
                ),
                label: item.label,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  int _calculateSelectedIndex(BuildContext context, List<NavItem> items) {
    final location = GoRouterState.of(context).matchedLocation;

    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index, List<NavItem> items) {
    if (index < items.length) {
      context.go(items[index].route);
    }
  }
}

/// Admin app shell with bottom navigation
class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return child;
        }

        final navItems = RoleBasedNavigator.getBottomNavItems(UserRole.admin);
        final currentIndex = _calculateSelectedIndex(context, navItems);

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              _onItemTapped(context, index, navItems);
            },
            destinations: navItems.map((item) {
              return NavigationDestination(
                icon: Icon(item.icon),
                selectedIcon: Icon(item.activeIcon ?? item.icon),
                label: item.label,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  int _calculateSelectedIndex(BuildContext context, List<NavItem> items) {
    final location = GoRouterState.of(context).matchedLocation;

    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index, List<NavItem> items) {
    if (index < items.length) {
      context.go(items[index].route);
    }
  }
}
