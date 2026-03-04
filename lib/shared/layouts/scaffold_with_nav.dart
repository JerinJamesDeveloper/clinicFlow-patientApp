/// Scaffold With Navigation
/// 
/// Main app scaffold with bottom navigation bar.
/// Handles navigation state and role-based menu items.
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../features/auth/domain/entities/user_entity.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../navigation/role_based_navigator.dart';

/// Main scaffold with bottom navigation
class ScaffoldWithNav extends StatelessWidget {
  /// Child widget (current page)
  final Widget child;
  
  /// Current route location
  final String currentLocation;

  const ScaffoldWithNav({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return child;
        }

        final user = state.user;
        final navItems = RoleBasedNavigator.getBottomNavItems(user.role);
        final currentIndex = _calculateSelectedIndex(currentLocation, navItems);

        return Scaffold(
          body: child,
          bottomNavigationBar: _BottomNavBar(
            items: navItems,
            currentIndex: currentIndex,
            onItemSelected: (index) => _onItemTapped(context, index, navItems),
          ),
        );
      },
    );
  }

  int _calculateSelectedIndex(String location, List<NavItem> items) {
    for (int i = 0; i < items.length; i++) {
      if (location.startsWith(items[i].route)) {
        return i;
      }
    }
    return 0;
  }

  void _onItemTapped(BuildContext context, int index, List<NavItem> items) {
    if (index < items.length) {
      final route = items[index].route;
      
      // Only navigate if we're not already on this route
      if (!context.mounted) return;
      
      final currentLocation = GoRouterState.of(context).matchedLocation;
      if (!currentLocation.startsWith(route)) {
        context.go(route);
      }
    }
  }
}

/// Bottom navigation bar widget
class _BottomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const _BottomNavBar({
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _NavBarItem(
                item: item,
                isSelected: isSelected,
                onTap: () => onItemSelected(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Single navigation bar item
class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge wrapper
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.grey400 : AppColors.grey500),
                  size: 24,
                ),
                if ((item.badgeCount ?? 0) > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        item.badgeCount! > 9 ? '9+' : '${item.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.grey400 : AppColors.grey500),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating bottom navigation bar variant
class FloatingBottomNavBar extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const FloatingBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = index == currentIndex;

          return GestureDetector(
            onTap: () => onItemSelected(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.grey400 : AppColors.grey500),
                    size: 22,
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    Text(
                      item.label,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Scaffold with floating bottom nav
class ScaffoldWithFloatingNav extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const ScaffoldWithFloatingNav({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return child;
        }

        final user = state.user;
        final navItems = RoleBasedNavigator.getBottomNavItems(user.role);
        final currentIndex = _calculateSelectedIndex(currentLocation, navItems);

        return Scaffold(
          body: child,
          extendBody: true,
          bottomNavigationBar: FloatingBottomNavBar(
            items: navItems,
            currentIndex: currentIndex,
            onItemSelected: (index) => _onItemTapped(context, index, navItems),
          ),
        );
      },
    );
  }

  int _calculateSelectedIndex(String location, List<NavItem> items) {
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