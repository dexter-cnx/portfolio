import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Transitional compatibility surface for the Technical Editorial redesign.
///
/// The original portfolio used frosted-glass containers. Public components still
/// reference this widget while they are migrated, so it now renders as a flat,
/// print-friendly editorial surface with a quiet outline and no backdrop blur.
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double backgroundOpacity;
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
    this.blur = 0,
    this.backgroundOpacity = 1,
    this.borderOpacity = 1,
    this.borderRadius = AppTheme.cardRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
    this.tintColor,
  });

  const GlassContainer.heavy({
    super.key,
    required this.child,
    this.blur = 0,
    this.backgroundOpacity = 1,
    this.borderOpacity = 1,
    this.borderRadius = AppTheme.cardRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.boxShadow,
    this.tintColor,
  });

  const GlassContainer.light({
    super.key,
    required this.child,
    this.blur = 0,
    this.backgroundOpacity = 1,
    this.borderOpacity = 1,
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
    final background = tintColor ?? Colors.white;

    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppTheme.outline),
      ),
      child: child,
    );
  }
}
