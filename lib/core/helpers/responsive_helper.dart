import 'package:flutter/material.dart';

/// Breakpoints (match existing ResponsiveLayout class)
const double kMobileBreakpoint = 768;
const double kTabletBreakpoint = 1200;

/// Extension on [BuildContext] for ergonomic breakpoint checks.
///
/// Usage:
/// ```dart
/// if (context.isMobile) { ... }
/// final padding = context.responsive(mobile: 16.0, desktop: 48.0);
/// ```
extension ResponsiveHelper on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < kMobileBreakpoint;
  bool get isTablet =>
      screenWidth >= kMobileBreakpoint && screenWidth < kTabletBreakpoint;
  bool get isDesktop => screenWidth >= kTabletBreakpoint;

  /// Returns [mobile], [tablet], or [desktop] value based on current width.
  /// Falls back to [desktop] if [tablet] is omitted.
  T responsive<T>({
    required T mobile,
    T? tablet,
    required T desktop,
  }) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet ?? desktop;
    return mobile;
  }

  /// Horizontal section padding that scales with screen width.
  double get sectionPaddingH => responsive(mobile: 20.0, tablet: 40.0, desktop: 24.0);

  /// Hero font size for the main headline.
  double get heroFontSize => responsive(mobile: 44.0, tablet: 60.0, desktop: 80.0);

  /// Section title font size.
  double get sectionTitleSize => responsive(mobile: 22.0, tablet: 26.0, desktop: 28.0);

  /// Number of columns for a skill/project grid.
  int get skillGridColumns => responsive(mobile: 2, tablet: 3, desktop: 4);
  int get projectGridColumns => responsive(mobile: 1, tablet: 2, desktop: 3);
}
