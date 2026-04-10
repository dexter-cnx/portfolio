import 'dart:ui';

import 'package:flutter/material.dart';

/// Reusable glassmorphism container.
///
/// Renders a BackdropFilter blur behind a semi-transparent white overlay
/// with a subtle border — the classic "frosted glass" look.
///
/// Usage:
/// ```dart
/// GlassContainer(
///   padding: EdgeInsets.all(24),
///   child: Text('Hello glass'),
/// )
/// ```
class GlassContainer extends StatelessWidget {
  final Widget child;

  /// Blur strength. 12 is a good default; push to 20+ for heavy glass.
  final double blur;

  /// White overlay opacity. Keep below 0.12 for a subtle look.
  final double backgroundOpacity;

  /// Border opacity. ~0.15 works well against dark backgrounds.
  final double borderOpacity;

  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final List<BoxShadow>? boxShadow;
  final Color? tintColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 12,
    this.backgroundOpacity = 0.06,
    this.borderOpacity = 0.15,
    this.borderRadius = 16,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
    this.tintColor,
  });

  /// A more prominent variant with stronger blur — good for modals/cards.
  const GlassContainer.heavy({
    super.key,
    required this.child,
    this.blur = 24,
    this.backgroundOpacity = 0.10,
    this.borderOpacity = 0.20,
    this.borderRadius = 20,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
    this.tintColor,
  });

  /// A very subtle variant — useful as a nav bar background.
  const GlassContainer.light({
    super.key,
    required this.child,
    this.blur = 20,
    this.backgroundOpacity = 0.03,
    this.borderOpacity = 0.08,
    this.borderRadius = 0,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
    this.tintColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = tintColor ?? Colors.white;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            color: color.withValues(alpha: backgroundOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: color.withValues(alpha: borderOpacity),
              width: 1,
            ),
            boxShadow: boxShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}
