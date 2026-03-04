/// App Drawer
/// 
/// Side navigation drawer with user info and menu items.
/// Supports both regular and admin users.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../navigation/role_based_navigator.dart';

/// Main app drawer
class AppDrawer extends StatelessWidget {
  /// Currently active route
  final String? currentRoute;

  const AppDrawer({
    super.key,
    this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;
        final drawerItems = user != null
            ? RoleBasedNavigator.getDrawerItems(user.role)
            : <NavItem>[];

        return Drawer(
          child: Column(
            children: [
              // Header
              _DrawerHeader(user: user),

              // Menu Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Navigation items
                    ...drawerItems.map((item) => _DrawerMenuItem(
                          item: item,
                          isSelected: currentRoute?.startsWith(item.route) ?? false,
                          onTap: () {
                            Navigator.pop(context);
                            context.go(item.route);
                          },
                        )),

                    const Divider(height: 32),

                    // Settings
                    _DrawerMenuItem(
                      item: const NavItem(
                        route: '/settings',
                        icon: Icons.settings_outlined,
                        label: 'Settings',
                      ),
                      isSelected: currentRoute == '/settings',
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/settings');
                      },
                    ),

                    // Help
                    _DrawerMenuItem(
                      item: const NavItem(
                        route: '/help',
                        icon: Icons.help_outline,
                        label: 'Help & Support',
                      ),
                      isSelected: false,
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: Navigate to help
                      },
                    ),
                  ],
                ),
              ),

              // Footer
              _DrawerFooter(
                onLogout: () => _showLogoutDialog(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(context); // Close drawer
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

/// Drawer header with user info
class _DrawerHeader extends StatelessWidget {
  final UserEntity? user;

  const _DrawerHeader({this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: user?.avatarUrl != null
                  ? Image.network(
                      user!.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildInitials(),
                    )
                  : _buildInitials(),
            ),
          ),

          const SizedBox(height: 16),

          // Name
          Text(
            user?.fullName ?? 'Guest',
            style: AppTextStyles.titleMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          // Email
          Text(
            user?.email ?? '',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
          ),

          // Role badge
          if (user?.isAdmin ?? false) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.admin_panel_settings,
                    size: 14,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Admin',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        user?.initials ?? 'G',
        style: AppTextStyles.titleLarge.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Drawer menu item
class _DrawerMenuItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icon with badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.grey400 : AppColors.grey600),
                      size: 22,
                    ),
                    if ((item.badgeCount ?? 0) > 0)
                      Positioned(
                        right: -6,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            item.badgeCount! > 9 ? '9+' : '${item.badgeCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 16),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.grey300 : AppColors.grey700),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),

                // Arrow
                if (isSelected)
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Drawer footer with logout and version
class _DrawerFooter extends StatelessWidget {
  final VoidCallback onLogout;

  const _DrawerFooter({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkDivider : AppColors.grey200,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Version
          Text(
            '${AppConstants.appName} v${AppConstants.appVersion}',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.grey400,
            ),
          ),
        ],
      ),
    );
  }
}

/// Drawer with custom header
class CustomAppDrawer extends StatelessWidget {
  /// Custom header widget
  final Widget header;
  
  /// Menu items
  final List<DrawerItem> items;
  
  /// Footer widget
  final Widget? footer;
  
  /// Currently selected item index
  final int? selectedIndex;

  const CustomAppDrawer({
    super.key,
    required this.header,
    required this.items,
    this.footer,
    this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          header,
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                
                if (item.isDivider) {
                  return const Divider(height: 24);
                }

                return _DrawerMenuItem(
                  item: NavItem(
                    route: item.route ?? '',
                    icon: item.icon!,
                    label: item.label!,
                  ),
                  isSelected: selectedIndex == index,
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap?.call();
                  },
                );
              },
            ),
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

/// Drawer item data class
class DrawerItem {
  final IconData? icon;
  final String? label;
  final String? route;
  final VoidCallback? onTap;
  final bool isDivider;

  const DrawerItem({
    this.icon,
    this.label,
    this.route,
    this.onTap,
    this.isDivider = false,
  });

  const DrawerItem.divider()
      : icon = null,
        label = null,
        route = null,
        onTap = null,
        isDivider = true;
}