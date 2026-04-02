import 'dart:ui';

import 'package:flutter/material.dart';

/// Custom scroll behavior that enables mouse-drag scrolling on Flutter Web.
///
/// By default, Flutter Web only supports trackpad/scroll-wheel scrolling.
/// This override adds [PointerDeviceKind.mouse] to the set of drag devices,
/// allowing users to click-and-drag to scroll — matching native-like behavior.
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.mouse,
      };
}
