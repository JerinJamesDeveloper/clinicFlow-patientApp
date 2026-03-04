/// Loading Widgets
/// 
/// Reusable loading indicators for different use cases.
/// Includes full-screen, inline, and overlay loading states.
library;

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Full-screen loading widget
class LoadingWidget extends StatelessWidget {
  /// Optional loading message
  final String? message;
  
  /// Color of the loading indicator
  final Color? color;
  
  /// Size of the loading indicator
  final double size;
  
  /// Background color
  final Color? backgroundColor;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 40.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? AppColors.primary,
                ),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Inline loading indicator (for buttons, lists, etc.)
class LoadingIndicator extends StatelessWidget {
  /// Size of the indicator
  final double size;
  
  /// Color of the indicator
  final Color? color;
  
  /// Stroke width
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.size = 24.0,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

/// Loading overlay that covers the screen
class LoadingOverlay extends StatelessWidget {
  /// Child widget to show behind the overlay
  final Widget child;
  
  /// Whether to show the loading overlay
  final bool isLoading;
  
  /// Optional loading message
  final String? message;
  
  /// Overlay color
  final Color? overlayColor;
  
  /// Loading indicator color
  final Color? indicatorColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.overlayColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.mediumShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingIndicator(
                      size: 40,
                      color: indicatorColor,
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        message!,
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Shimmer loading effect for skeleton screens
class ShimmerLoading extends StatefulWidget {
  /// Width of the shimmer container
  final double? width;
  
  /// Height of the shimmer container
  final double height;
  
  /// Border radius
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: isDark
                  ? [
                      AppColors.grey800,
                      AppColors.grey700,
                      AppColors.grey800,
                    ]
                  : [
                      AppColors.grey200,
                      AppColors.grey100,
                      AppColors.grey200,
                    ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton card for loading states
class SkeletonCard extends StatelessWidget {
  /// Height of the card
  final double height;
  
  /// Whether to show image placeholder
  final bool hasImage;

  const SkeletonCard({
    super.key,
    this.height = 120,
    this.hasImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        children: [
          if (hasImage) ...[
            ShimmerLoading(
              width: height - 32,
              height: height - 32,
              borderRadius: 8,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                ShimmerLoading(width: double.infinity, height: 16),
                SizedBox(height: 8),
                ShimmerLoading(width: 150, height: 14),
                SizedBox(height: 8),
                ShimmerLoading(width: 100, height: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List of skeleton cards for loading state
class SkeletonList extends StatelessWidget {
  /// Number of skeleton items
  final int itemCount;
  
  /// Height of each card
  final double cardHeight;
  
  /// Spacing between cards
  final double spacing;
  
  /// Padding around the list
  final EdgeInsets padding;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.cardHeight = 100,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) => SkeletonCard(height: cardHeight),
    );
  }
}

/// Pulsating dot loading indicator
class PulsatingDots extends StatefulWidget {
  /// Color of the dots
  final Color? color;
  
  /// Size of each dot
  final double dotSize;
  
  /// Number of dots
  final int dotCount;

  const PulsatingDots({
    super.key,
    this.color,
    this.dotSize = 10,
    this.dotCount = 3,
  });

  @override
  State<PulsatingDots> createState() => _PulsatingDotsState();
}

class _PulsatingDotsState extends State<PulsatingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.dotCount,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with staggered delay
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.dotCount, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: widget.dotSize / 4),
              width: widget.dotSize,
              height: widget.dotSize,
              decoration: BoxDecoration(
                color: (widget.color ?? AppColors.primary)
                    .withOpacity(_animations[index].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}