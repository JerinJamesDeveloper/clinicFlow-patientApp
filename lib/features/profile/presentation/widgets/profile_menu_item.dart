/// Profile Menu Item Widget
/// 
/// Menu item for profile settings and options.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Profile menu item
class ProfileMenuItem extends StatelessWidget {
  /// Leading icon
  final IconData icon;
  
  /// Item title
  final String title;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Trailing widget
  final Widget? trailing;
  
  /// Icon color
  final Color? iconColor;
  
  /// Background color for icon
  final Color? iconBackgroundColor;
  
  /// Tap callback
  final VoidCallback? onTap;
  
  /// Whether to show chevron
  final bool showChevron;
  
  /// Whether this is a destructive action
  final bool isDestructive;
  
  /// Whether item is disabled
  final bool isDisabled;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.iconBackgroundColor,
    this.onTap,
    this.showChevron = true,
    this.isDestructive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveIconColor = isDestructive
        ? AppColors.error
        : (iconColor ?? AppColors.primary);
    final effectiveTextColor = isDestructive
        ? AppColors.error
        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary);

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (iconBackgroundColor ?? effectiveIconColor)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: effectiveIconColor,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Title & Subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: effectiveTextColor,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Trailing
                if (trailing != null)
                  trailing!
                else if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.grey400,
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

/// Profile menu section with title and items
class ProfileMenuSection extends StatelessWidget {
  /// Section title
  final String? title;
  
  /// Menu items
  final List<Widget> items;
  
  /// Padding around section
  final EdgeInsets padding;

  const ProfileMenuSection({
    super.key,
    this.title,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 8),
              child: Text(
                title!.toUpperCase(),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey500,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkDivider : AppColors.grey200,
              ),
            ),
            child: Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                
                return Column(
                  children: [
                    item,
                    if (index < items.length - 1)
                      Divider(
                        height: 1,
                        indent: 68,
                        color: isDark
                            ? AppColors.darkDivider
                            : AppColors.grey200,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggle menu item with switch
class ProfileToggleMenuItem extends StatelessWidget {
  /// Leading icon
  final IconData icon;
  
  /// Item title
  final String title;
  
  /// Optional subtitle
  final String? subtitle;
  
  /// Current value
  final bool value;
  
  /// Value changed callback
  final ValueChanged<bool>? onChanged;
  
  /// Icon color
  final Color? iconColor;
  
  /// Whether item is disabled
  final bool isDisabled;

  const ProfileToggleMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.iconColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileMenuItem(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      showChevron: false,
      isDisabled: isDisabled,
      trailing: Switch.adaptive(
        value: value,
        onChanged: isDisabled ? null : onChanged,
        activeColor: AppColors.primary,
      ),
      onTap: isDisabled
          ? null
          : () => onChanged?.call(!value),
    );
  }
}

/// Info menu item (display only, no action)
class ProfileInfoMenuItem extends StatelessWidget {
  /// Leading icon
  final IconData icon;
  
  /// Item title
  final String title;
  
  /// Value to display
  final String value;
  
  /// Icon color
  final Color? iconColor;

  const ProfileInfoMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileMenuItem(
      icon: icon,
      title: title,
      iconColor: iconColor,
      showChevron: false,
      trailing: Text(
        value,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.grey500,
        ),
      ),
    );
  }
}