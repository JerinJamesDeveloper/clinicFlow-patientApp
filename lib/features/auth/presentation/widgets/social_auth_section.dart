/// Social Auth Section Widget
/// 
/// Section with social login buttons (Google, Apple, etc.)
/// Used on login and register pages.
library;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Social authentication section
class SocialAuthSection extends StatelessWidget {
  /// Callback for Google sign in
  final VoidCallback? onGoogleSignIn;
  
  /// Callback for Apple sign in
  final VoidCallback? onAppleSignIn;
  
  /// Whether Google sign in is loading
  final bool isGoogleLoading;
  
  /// Whether Apple sign in is loading
  final bool isAppleLoading;
  
  /// Whether to show Apple sign in (only on iOS/macOS)
  final bool showApple;
  
  /// Title text above buttons
  final String? title;

  const SocialAuthSection({
    super.key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.isGoogleLoading = false,
    this.isAppleLoading = false,
    this.showApple = true,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Google Sign In
        _GoogleSignInButton(
          onPressed: onGoogleSignIn,
          isLoading: isGoogleLoading,
        ),
        
        // Apple Sign In (conditional)
        if (showApple) ...[
          const SizedBox(height: 12),
          _AppleSignInButton(
            onPressed: onAppleSignIn,
            isLoading: isAppleLoading,
          ),
        ],
      ],
    );
  }
}

/// Google sign in button
class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GoogleSignInButton({
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.grey800,
          side: const BorderSide(color: AppColors.grey300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Icon (you can replace with actual Google logo)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: const Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Apple sign in button
class _AppleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _AppleSignInButton({
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.black,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Continue with Apple',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Compact social auth row (icons only)
class SocialAuthRow extends StatelessWidget {
  /// Callback for Google sign in
  final VoidCallback? onGoogleSignIn;
  
  /// Callback for Apple sign in
  final VoidCallback? onAppleSignIn;
  
  /// Callback for Facebook sign in
  final VoidCallback? onFacebookSignIn;
  
  /// Whether to show Apple button
  final bool showApple;
  
  /// Whether to show Facebook button
  final bool showFacebook;

  const SocialAuthRow({
    super.key,
    this.onGoogleSignIn,
    this.onAppleSignIn,
    this.onFacebookSignIn,
    this.showApple = true,
    this.showFacebook = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _SocialIconButton(
          icon: const Text(
            'G',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: onGoogleSignIn,
          backgroundColor: AppColors.white,
          borderColor: AppColors.grey300,
        ),
        
        // Apple
        if (showApple) ...[
          const SizedBox(width: 16),
          _SocialIconButton(
            icon: const Icon(Icons.apple, color: AppColors.white, size: 24),
            onPressed: onAppleSignIn,
            backgroundColor: AppColors.black,
          ),
        ],
        
        // Facebook
        if (showFacebook) ...[
          const SizedBox(width: 16),
          _SocialIconButton(
            icon: const Text(
              'f',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: onFacebookSignIn,
            backgroundColor: const Color(0xFF1877F2),
          ),
        ],
      ],
    );
  }
}

/// Social icon button
class _SocialIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? borderColor;

  const _SocialIconButton({
    required this.icon,
    this.onPressed,
    required this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: borderColor != null
                ? Border.all(color: borderColor!)
                : null,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}