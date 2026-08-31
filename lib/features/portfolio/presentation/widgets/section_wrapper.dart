import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import 'responsive_layout.dart';

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final String? id;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;

  const SectionWrapper({
    super.key,
    required this.child,
    this.id,
    this.padding,
    this.maxWidth = AppTheme.contentMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final horizontal = ResponsiveLayout.isMobile(context)
        ? AppTheme.mobileGutter
        : AppTheme.desktopGutter;

    return Container(
      key: id != null ? ValueKey(id) : null,
      width: double.infinity,
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: horizontal,
            vertical: AppTheme.sectionGap,
          ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}
