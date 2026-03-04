/// Auth Header Widget
/// 
/// Reusable header for authentication pages.
/// Displays logo, title, and optional subtitle.
library;

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Header widget for auth pages
class AuthHeader extends StatelessWidget {
  /// Main title text
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Whether to show the logo
  final bool showLogo;
  
  /// Custom logo widget
  final Widget? logo;
  
  /// Spacing between logo and title
  final double logoSpacing;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
    this.logo,
    this.logoSpacing = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showLogo) ...[
          logo ?? _buildDefaultLogo(context),
          SizedBox(height: logoSpacing),
        ],
        Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultLogo(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.lock_outline_rounded,
          size: 40,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Animated auth header with fade-in effect
class AnimatedAuthHeader extends StatefulWidget {
  /// Main title text
  final String title;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Whether to show the logo
  final bool showLogo;
  
  /// Animation duration
  final Duration duration;

  const AnimatedAuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showLogo = true,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<AnimatedAuthHeader> createState() => _AnimatedAuthHeaderState();
}

class _AnimatedAuthHeaderState extends State<AnimatedAuthHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: AuthHeader(
          title: widget.title,
          subtitle: widget.subtitle,
          showLogo: widget.showLogo,
        ),
      ),
    );
  }
}

/// Welcome back header for login page
class WelcomeHeader extends StatelessWidget {
  /// User's name (optional, for returning users)
  final String? userName;

  const WelcomeHeader({
    super.key,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return AuthHeader(
      title: userName != null ? 'Welcome back!' : 'Welcome',
      subtitle: userName != null
          ? 'Sign in to continue as $userName'
          : 'Sign in to your account to continue',
    );
  }
}

/// Create account header for register page
class CreateAccountHeader extends StatelessWidget {
  const CreateAccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthHeader(
      title: 'Create Account',
      subtitle: 'Sign up to get started',
    );
  }
}

/// Forgot password header
class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuthHeader(
      title: 'Forgot Password?',
      subtitle: 'Enter your email and we\'ll send you a reset link',
      logo: Icon(
        Icons.lock_reset_rounded,
        size: 60,
        color: AppColors.primary,
      ),
    );
  }
}