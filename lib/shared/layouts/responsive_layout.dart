/// Responsive Layout
/// 
/// Responsive layout utilities for different screen sizes.
/// Supports mobile, tablet, and desktop layouts.
library;

import 'package:flutter/material.dart';

/// Screen breakpoints
class ScreenBreakpoints {
  ScreenBreakpoints._();

  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
  static const double largeDesktop = 1800;
}

/// Screen size type
enum ScreenSize { mobile, tablet, desktop, largeDesktop }

/// Responsive layout builder
class ResponsiveLayout extends StatelessWidget {
  /// Mobile layout (required)
  final Widget mobile;
  
  /// Tablet layout (optional, defaults to mobile)
  final Widget? tablet;
  
  /// Desktop layout (optional, defaults to tablet or mobile)
  final Widget? desktop;
  
  /// Large desktop layout (optional, defaults to desktop)
  final Widget? largeDesktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  /// Get current screen size type
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width >= ScreenBreakpoints.largeDesktop) {
      return ScreenSize.largeDesktop;
    } else if (width >= ScreenBreakpoints.desktop) {
      return ScreenSize.desktop;
    } else if (width >= ScreenBreakpoints.tablet) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.mobile;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    final size = getScreenSize(context);
    return size == ScreenSize.desktop || size == ScreenSize.largeDesktop;
  }

  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= ScreenBreakpoints.largeDesktop) {
          return largeDesktop ?? desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ScreenBreakpoints.desktop) {
          return desktop ?? tablet ?? mobile;
        } else if (constraints.maxWidth >= ScreenBreakpoints.tablet) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}

/// Responsive value builder
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  /// Get value for current screen size
  T get(BuildContext context) {
    final size = ResponsiveLayout.getScreenSize(context);
    
    switch (size) {
      case ScreenSize.largeDesktop:
        return largeDesktop ?? desktop ?? tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.mobile:
        return mobile;
    }
  }
}

/// Responsive padding
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobile;
  final EdgeInsets? tablet;
  final EdgeInsets? desktop;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveValue<EdgeInsets>(
      mobile: mobile ?? const EdgeInsets.all(16),
      tablet: tablet ?? const EdgeInsets.all(24),
      desktop: desktop ?? const EdgeInsets.all(32),
    ).get(context);

    return Padding(
      padding: padding,
      child: child,
    );
  }
}

/// Responsive grid
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileCrossAxisCount;
  final int tabletCrossAxisCount;
  final int desktopCrossAxisCount;
  final double spacing;
  final double childAspectRatio;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileCrossAxisCount = 2,
    this.tabletCrossAxisCount = 3,
    this.desktopCrossAxisCount = 4,
    this.spacing = 16,
    this.childAspectRatio = 1,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveValue<int>(
      mobile: mobileCrossAxisCount,
      tablet: tabletCrossAxisCount,
      desktop: desktopCrossAxisCount,
    ).get(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Responsive container with max width
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;
  final Alignment alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Responsive row that wraps to column on mobile
class ResponsiveRowColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment rowMainAxisAlignment;
  final CrossAxisAlignment rowCrossAxisAlignment;
  final MainAxisAlignment columnMainAxisAlignment;
  final CrossAxisAlignment columnCrossAxisAlignment;
  final double spacing;

  const ResponsiveRowColumn({
    super.key,
    required this.children,
    this.rowMainAxisAlignment = MainAxisAlignment.start,
    this.rowCrossAxisAlignment = CrossAxisAlignment.center,
    this.columnMainAxisAlignment = MainAxisAlignment.start,
    this.columnCrossAxisAlignment = CrossAxisAlignment.stretch,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isMobile(context)) {
      return Column(
        mainAxisAlignment: columnMainAxisAlignment,
        crossAxisAlignment: columnCrossAxisAlignment,
        children: _addSpacing(children, isRow: false),
      );
    }

    return Row(
      mainAxisAlignment: rowMainAxisAlignment,
      crossAxisAlignment: rowCrossAxisAlignment,
      children: _addSpacing(children, isRow: true),
    );
  }

  List<Widget> _addSpacing(List<Widget> widgets, {required bool isRow}) {
    final result = <Widget>[];
    
    for (int i = 0; i < widgets.length; i++) {
      if (isRow) {
        result.add(Expanded(child: widgets[i]));
      } else {
        result.add(widgets[i]);
      }
      
      if (i < widgets.length - 1) {
        result.add(SizedBox(
          width: isRow ? spacing : 0,
          height: isRow ? 0 : spacing,
        ));
      }
    }
    
    return result;
  }
}

/// Extension for responsive values
extension ResponsiveExtension on BuildContext {
  /// Get screen size type
  ScreenSize get screenSize => ResponsiveLayout.getScreenSize(this);
  
  /// Check if mobile
  bool get isMobile => ResponsiveLayout.isMobile(this);
  
  /// Check if tablet
  bool get isTablet => ResponsiveLayout.isTablet(this);
  
  /// Check if desktop
  bool get isDesktop => ResponsiveLayout.isDesktop(this);
  
  /// Get responsive value
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ResponsiveValue<T>(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    ).get(this);
  }
}