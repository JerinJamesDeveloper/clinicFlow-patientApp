/// Role-Based Navigator
/// 
/// Handles role-based access control and navigation items.
/// Defines permissions and accessible routes for each role.
library;

import 'package:flutter/material.dart';

import '../features/auth/domain/entities/user_entity.dart';

/// Navigation item configuration
class NavItem {
  /// Route path
  final String route;
  
  /// Display icon
  final IconData icon;
  
  /// Selected/Active icon
  final IconData? activeIcon;
  
  /// Display label
  final String label;
  
  /// Badge count (for notifications, etc.)
  final int? badgeCount;
  
  /// Required permission to see this item
  final String? requiredPermission;

  const NavItem({
    required this.route,
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount,
    this.requiredPermission,
  });

  /// Creates a copy with updated badge count
  NavItem copyWithBadge(int? count) {
    return NavItem(
      route: route,
      icon: icon,
      activeIcon: activeIcon,
      label: label,
      badgeCount: count,
      requiredPermission: requiredPermission,
    );
  }
}

/// Permission constants
class Permissions {
  Permissions._();

  // User permissions
  static const String viewProfile = 'view_profile';
  static const String editProfile = 'edit_profile';
  static const String viewNotifications = 'view_notifications';

  // Admin permissions
  static const String viewDashboard = 'view_dashboard';
  static const String manageUsers = 'manage_users';
  static const String viewAnalytics = 'view_analytics';
  static const String manageSettings = 'manage_settings';
  static const String viewReports = 'view_reports';
}

/// Role-based navigation manager
class RoleBasedNavigator {
  RoleBasedNavigator._();

  // ============== ROLE PERMISSIONS ==============
  
  /// Permissions granted to each role
  static final Map<UserRole, Set<String>> _rolePermissions = {
    UserRole.user: {
      Permissions.viewProfile,
      Permissions.editProfile,
      Permissions.viewNotifications,
    },
    UserRole.admin: {
      // Admin inherits all user permissions
      Permissions.viewProfile,
      Permissions.editProfile,
      Permissions.viewNotifications,
      // Admin-specific permissions
      Permissions.viewDashboard,
      Permissions.manageUsers,
      Permissions.viewAnalytics,
      Permissions.manageSettings,
      Permissions.viewReports,
    },
  };

  // ============== NAVIGATION ITEMS ==============
  
  /// Bottom navigation items for regular users
  static const List<NavItem> _userNavItems = [
    NavItem(
      route: '/home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    // NavItem(
    //   route: '/notifications',
    //   icon: Icons.notifications_outlined,
    //   activeIcon: Icons.notifications,
    //   label: 'Notifications',
    //   requiredPermission: Permissions.viewNotifications,
    // ),
    NavItem(
      route: '/profile',
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
      label: 'Profile',
      requiredPermission: Permissions.viewProfile,
    ),
  ];

  /// Bottom navigation items for admin users
  static const List<NavItem> _adminNavItems = [
    NavItem(
      route: '/admin/home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Home',
    ),
    NavItem(
      route: '/admin/dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      requiredPermission: Permissions.viewDashboard,
    ),
    NavItem(
      route: '/admin/users',
      icon: Icons.people_outlined,
      activeIcon: Icons.people,
      label: 'Users',
      requiredPermission: Permissions.manageUsers,
    ),
    NavItem(
      route: '/profile',
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
      label: 'Profile',
    ),
  ];

  /// Drawer/Side menu items for regular users
  static const List<NavItem> _userDrawerItems = [
    NavItem(
      route: '/home',
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    NavItem(
      route: '/profile',
      icon: Icons.person_outlined,
      label: 'Profile',
    ),
    NavItem(
      route: '/notifications',
      icon: Icons.notifications_outlined,
      label: 'Notifications',
    ),
    NavItem(
      route: '/settings',
      icon: Icons.settings_outlined,
      label: 'Settings',
    ),
  ];

  /// Drawer/Side menu items for admin users
  static const List<NavItem> _adminDrawerItems = [
    NavItem(
      route: '/admin/home',
      icon: Icons.home_outlined,
      label: 'Home',
    ),
    NavItem(
      route: '/admin/dashboard',
      icon: Icons.dashboard_outlined,
      label: 'Dashboard',
      requiredPermission: Permissions.viewDashboard,
    ),
    NavItem(
      route: '/admin/users',
      icon: Icons.people_outlined,
      label: 'Users',
      requiredPermission: Permissions.manageUsers,
    ),
    NavItem(
      route: '/profile',
      icon: Icons.person_outlined,
      label: 'Profile',
    ),
    NavItem(
      route: '/admin/settings',
      icon: Icons.settings_outlined,
      label: 'Settings',
      requiredPermission: Permissions.manageSettings,
    ),
  ];

  // ============== PUBLIC METHODS ==============

  /// Checks if a role has a specific permission
  static bool hasPermission(UserRole role, String permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }

  /// Checks if a role has all specified permissions
  static bool hasAllPermissions(UserRole role, List<String> permissions) {
    return permissions.every((p) => hasPermission(role, p));
  }

  /// Checks if a role has any of the specified permissions
  static bool hasAnyPermission(UserRole role, List<String> permissions) {
    return permissions.any((p) => hasPermission(role, p));
  }

  /// Gets all permissions for a role
  static Set<String> getPermissions(UserRole role) {
    return _rolePermissions[role] ?? {};
  }

  /// Gets the bottom navigation items for a role
  static List<NavItem> getBottomNavItems(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return _adminNavItems;
      case UserRole.user:
      default:
        return _userNavItems;
    }
  }

  /// Gets the drawer/side menu items for a role
  static List<NavItem> getDrawerItems(UserRole role) {
    final items = role == UserRole.admin 
        ? _adminDrawerItems 
        : _userDrawerItems;

    // Filter items based on permissions
    return items.where((item) {
      if (item.requiredPermission == null) return true;
      return hasPermission(role, item.requiredPermission!);
    }).toList();
  }

  /// Gets the initial route for a role after login
  static String getInitialRoute(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return '/admin/home';
      case UserRole.user:
      default:
        return '/home';
    }
  }

  /// Gets the home route for a role
  static String getHomeRoute(UserRole role) {
    return getInitialRoute(role);
  }

  /// Checks if a route is accessible by a role
  static bool canAccessRoute(UserRole role, String route) {
    // Public routes accessible by all authenticated users
    const publicRoutes = [
      '/home',
      '/profile',
      '/profile/edit',
      '/settings',
      '/settings/change-password',
      '/notifications',
    ];

    if (publicRoutes.contains(route)) {
      return true;
    }

    // Admin-only routes
    if (route.startsWith('/admin')) {
      return role == UserRole.admin;
    }

    return true;
  }

  /// Gets the redirect route when access is denied
  static String getAccessDeniedRedirect(UserRole role) {
    return getInitialRoute(role);
  }

  /// Gets route-specific required permissions
  static List<String>? getRoutePermissions(String route) {
    const routePermissions = <String, List<String>>{
      '/admin/dashboard': [Permissions.viewDashboard],
      '/admin/users': [Permissions.manageUsers],
      '/admin/settings': [Permissions.manageSettings],
    };

    return routePermissions[route];
  }
}

/// Extension on UserEntity for permission checks
extension UserPermissions on UserEntity {
  /// Checks if user has a specific permission
  bool hasPermission(String permission) {
    return RoleBasedNavigator.hasPermission(role, permission);
  }

  /// Checks if user has all specified permissions
  bool hasAllPermissions(List<String> permissions) {
    return RoleBasedNavigator.hasAllPermissions(role, permissions);
  }

  /// Checks if user has any of the specified permissions
  bool hasAnyPermission(List<String> permissions) {
    return RoleBasedNavigator.hasAnyPermission(role, permissions);
  }

  /// Checks if user can access a route
  bool canAccessRoute(String route) {
    return RoleBasedNavigator.canAccessRoute(role, route);
  }

  /// Gets the user's home route
  String get homeRoute => RoleBasedNavigator.getHomeRoute(role);

  /// Gets bottom nav items for this user
  List<NavItem> get bottomNavItems => RoleBasedNavigator.getBottomNavItems(role);

  /// Gets drawer items for this user
  List<NavItem> get drawerItems => RoleBasedNavigator.getDrawerItems(role);
}

/// Widget that shows/hides based on permission
class PermissionGuard extends StatelessWidget {
  /// Required permission to show child
  final String permission;
  
  /// Child widget to show if permission granted
  final Widget child;
  
  /// Widget to show if permission denied (optional)
  final Widget? fallback;
  
  /// User to check permission for
  final UserEntity user;

  const PermissionGuard({
    super.key,
    required this.permission,
    required this.child,
    required this.user,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (user.hasPermission(permission)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}

/// Widget that shows/hides based on role
class RoleGuard extends StatelessWidget {
  /// Required roles to show child
  final List<UserRole> allowedRoles;
  
  /// Child widget to show if role matches
  final Widget child;
  
  /// Widget to show if role doesn't match (optional)
  final Widget? fallback;
  
  /// User to check role for
  final UserEntity user;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
    required this.user,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    if (allowedRoles.contains(user.role)) {
      return child;
    }
    return fallback ?? const SizedBox.shrink();
  }
}