import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 768 && MediaQuery.sizeOf(context).width < 1200;

  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1200;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1200) {
      return desktop;
    } else if (width >= 768) {
      return tablet ?? desktop;
    } else {
      return mobile;
    }
  }
}
