/// Auth Form Wrapper Widget
/// 
/// Wrapper widget for auth forms providing consistent styling,
/// keyboard handling, and scroll behavior.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';

/// Wrapper for authentication forms
class AuthFormWrapper extends StatelessWidget {
  /// Child widget (usually a Form)
  final Widget child;
  
  /// Whether form is in loading state
  final bool isLoading;
  
  /// Loading message
  final String? loadingMessage;
  
  /// Padding around the form
  final EdgeInsets padding;
  
  /// Whether to add safe area padding
  final bool useSafeArea;
  
  /// Maximum width for the form (for tablets/web)
  final double maxWidth;

  const AuthFormWrapper({
    super.key,
    required this.child,
    this.isLoading = false,
    this.loadingMessage,
    this.padding = const EdgeInsets.all(24),
    this.useSafeArea = true,
    this.maxWidth = 400,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = LoadingOverlay(
      isLoading: isLoading,
      message: loadingMessage,
      child: SingleChildScrollView(
        padding: padding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        ),
      ),
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: content,
    );
  }
}

/// Auth page scaffold with consistent styling
class AuthScaffold extends StatelessWidget {
  /// Page body
  final Widget body;
  
  /// Optional app bar
  final PreferredSizeWidget? appBar;
  
  /// Whether to show back button
  final bool showBackButton;
  
  /// Custom back button action
  final VoidCallback? onBackPressed;
  
  /// Background color
  final Color? backgroundColor;
  
  /// Whether page is in loading state
  final bool isLoading;
  
  /// Loading message
  final String? loadingMessage;

  const AuthScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showBackButton = false,
    this.onBackPressed,
    this.backgroundColor,
    this.isLoading = false,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar ?? (showBackButton ? _buildAppBar(context) : null),
      body: LoadingOverlay(
        isLoading: isLoading,
        message: loadingMessage,
        child: body,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// Divider with "or" text for social login separation
class AuthDivider extends StatelessWidget {
  /// Text to display (default: "or")
  final String text;

  const AuthDivider({
    super.key,
    this.text = 'or',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.grey600 : AppColors.grey400;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: color, thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: color, thickness: 1),
          ),
        ],
      ),
    );
  }
}

/// Footer with navigation link (e.g., "Don't have an account? Sign up")
class AuthFooter extends StatelessWidget {
  /// Leading text
  final String text;
  
  /// Link text
  final String linkText;
  
  /// Link action
  final VoidCallback onLinkTap;

  const AuthFooter({
    super.key,
    required this.text,
    required this.linkText,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 14,
            ),
          ),
          TextButton(
            onPressed: onLinkTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              linkText,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Terms and conditions checkbox widget
class TermsCheckbox extends StatelessWidget {
  /// Whether terms are accepted
  final bool value;
  
  /// Callback when value changes
  final ValueChanged<bool?> onChanged;
  
  /// Optional error message
  final String? errorText;
  
  /// Terms URL callback
  final VoidCallback? onTermsTap;
  
  /// Privacy URL callback
  final VoidCallback? onPrivacyTap;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.onTermsTap,
    this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: AppColors.grey600,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(text: 'I agree to the '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: onTermsTap,
                          child: Text(
                            'Terms of Service',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(text: ' and '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: onPrivacyTap,
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Remember me checkbox widget
class RememberMeCheckbox extends StatelessWidget {
  /// Whether remember me is checked
  final bool value;
  
  /// Callback when value changes
  final ValueChanged<bool?> onChanged;
  
  /// Optional forgot password callback
  final VoidCallback? onForgotPassword;

  const RememberMeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => onChanged(!value),
              child: Text(
                'Remember me',
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        if (onForgotPassword != null)
          TextButton(
            onPressed: onForgotPassword,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}