/// App Button Widgets
/// 
/// Reusable button components with consistent styling.
/// Includes primary, secondary, outlined, and text button variants.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import 'loading_widget.dart';

/// Button size variants
enum AppButtonSize { small, medium, large }

/// Button variant types
enum AppButtonVariant { primary, secondary, outlined, text, danger }

/// Primary app button with loading state support
class AppButton extends StatelessWidget {
  /// Button text
  final String text;
  
  /// On press callback
  final VoidCallback? onPressed;
  
  /// Loading state
  final bool isLoading;
  
  /// Disabled state
  final bool isDisabled;
  
  /// Button size
  final AppButtonSize size;
  
  /// Button variant
  final AppButtonVariant variant;
  
  /// Optional leading icon
  final IconData? leadingIcon;
  
  /// Optional trailing icon
  final IconData? trailingIcon;
  
  /// Full width button
  final bool fullWidth;
  
  /// Custom background color
  final Color? backgroundColor;
  
  /// Custom text color
  final Color? textColor;
  
  /// Custom border radius
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = AppButtonSize.medium,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;
    
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: _getHeight(),
      child: _buildButton(context, isEnabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isEnabled) {
    switch (variant) {
      case AppButtonVariant.primary:
        return _buildPrimaryButton(context, isEnabled);
      case AppButtonVariant.secondary:
        return _buildSecondaryButton(context, isEnabled);
      case AppButtonVariant.outlined:
        return _buildOutlinedButton(context, isEnabled);
      case AppButtonVariant.text:
        return _buildTextButton(context, isEnabled);
      case AppButtonVariant.danger:
        return _buildDangerButton(context, isEnabled);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: textColor ?? AppColors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.defaultRadius,
          ),
        ),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
      ),
      child: _buildChild(textColor ?? AppColors.white),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.secondary,
        foregroundColor: textColor ?? AppColors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.defaultRadius,
          ),
        ),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
      ),
      child: _buildChild(textColor ?? AppColors.white),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        side: BorderSide(
          color: isEnabled 
              ? (backgroundColor ?? AppColors.primary) 
              : AppColors.grey300,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.defaultRadius,
          ),
        ),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
      ),
      child: _buildChild(textColor ?? AppColors.primary),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.defaultRadius,
          ),
        ),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
      ),
      child: _buildChild(textColor ?? AppColors.primary),
    );
  }

  Widget _buildDangerButton(BuildContext context, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.error,
        foregroundColor: textColor ?? AppColors.white,
        disabledBackgroundColor: AppColors.grey300,
        disabledForegroundColor: AppColors.grey500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppConstants.defaultRadius,
          ),
        ),
        textStyle: _getTextStyle(),
        padding: _getPadding(),
      ),
      child: _buildChild(textColor ?? AppColors.white),
    );
  }

  Widget _buildChild(Color color) {
    if (isLoading) {
      return LoadingIndicator(
        size: _getLoadingSize(),
        color: variant == AppButtonVariant.outlined || 
               variant == AppButtonVariant.text
            ? AppColors.primary
            : AppColors.white,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (leadingIcon != null) ...[
          Icon(leadingIcon, size: _getIconSize()),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: _getIconSize()),
        ],
      ],
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTextStyles.buttonSmall;
      case AppButtonSize.medium:
        return AppTextStyles.buttonMedium;
      case AppButtonSize.large:
        return AppTextStyles.buttonLarge;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }
}

/// Icon button with consistent styling
class AppIconButton extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// On press callback
  final VoidCallback? onPressed;
  
  /// Icon color
  final Color? iconColor;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Icon size
  final double size;
  
  /// Is loading
  final bool isLoading;
  
  /// Tooltip text
  final String? tooltip;
  
  /// Border radius
  final double? borderRadius;
  
  /// Border color
  final Color? borderColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size = 24,
    this.isLoading = false,
    this.tooltip,
    this.borderRadius,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final button = Container(
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        border: borderColor != null 
            ? Border.all(color: borderColor!) 
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          child: Center(
            child: isLoading
                ? LoadingIndicator(
                    size: size * 0.75,
                    color: iconColor ?? AppColors.grey600,
                  )
                : Icon(
                    icon,
                    size: size,
                    color: onPressed != null 
                        ? (iconColor ?? AppColors.grey600)
                        : AppColors.grey400,
                  ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Floating action button with consistent styling
class AppFloatingButton extends StatelessWidget {
  /// Icon to display
  final IconData icon;
  
  /// On press callback
  final VoidCallback? onPressed;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Icon color
  final Color? iconColor;
  
  /// Optional label for extended FAB
  final String? label;
  
  /// Is loading
  final bool isLoading;
  
  /// Mini FAB
  final bool mini;

  const AppFloatingButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.label,
    this.isLoading = false,
    this.mini = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      return FloatingActionButton.extended(
        onPressed: isLoading ? null : onPressed,
        backgroundColor: backgroundColor ?? AppColors.primary,
        foregroundColor: iconColor ?? AppColors.white,
        icon: isLoading
            ? LoadingIndicator(
                size: 20,
                color: iconColor ?? AppColors.white,
              )
            : Icon(icon),
        label: Text(label!),
      );
    }

    return FloatingActionButton(
      onPressed: isLoading ? null : onPressed,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: iconColor ?? AppColors.white,
      mini: mini,
      child: isLoading
          ? LoadingIndicator(
              size: mini ? 16 : 24,
              color: iconColor ?? AppColors.white,
            )
          : Icon(icon),
    );
  }
}

/// Social login button
class SocialButton extends StatelessWidget {
  /// Button text
  final String text;
  
  /// On press callback
  final VoidCallback? onPressed;
  
  /// Social icon widget (usually an SVG)
  final Widget icon;
  
  /// Is loading
  final bool isLoading;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Text color
  final Color? textColor;
  
  /// Border color
  final Color? borderColor;

  const SocialButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  /// Google sign in button
  factory SocialButton.google({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialButton(
      text: 'Continue with Google',
      icon: const Icon(Icons.g_mobiledata, size: 24), // Replace with Google SVG
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.white,
      textColor: AppColors.grey800,
      borderColor: AppColors.grey300,
    );
  }

  /// Apple sign in button
  factory SocialButton.apple({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SocialButton(
      text: 'Continue with Apple',
      icon: const Icon(Icons.apple, size: 24), // Replace with Apple SVG
      onPressed: onPressed,
      isLoading: isLoading,
      backgroundColor: AppColors.black,
      textColor: AppColors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.white,
          foregroundColor: textColor ?? AppColors.grey800,
          side: BorderSide(
            color: borderColor ?? AppColors.grey300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultRadius),
          ),
        ),
        child: isLoading
            ? LoadingIndicator(
                size: 20,
                color: textColor ?? AppColors.grey800,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    text,
                    style: AppTextStyles.buttonMedium.copyWith(
                      color: textColor ?? AppColors.grey800,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}