import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Plays a fade + slide-up + optional scale animation the first time
/// the widget scrolls into the viewport.
///
/// This is the **Cue.onScrollVisible** equivalent:
/// ```dart
/// ScrollReveal(
///   delay: 200.ms,
///   child: MyWidget(),
/// )
/// ```
///
/// For staggered lists, pass incremental [delay] values:
/// ```dart
/// for (var i = 0; i < items.length; i++)
///   ScrollReveal(delay: (i * 80).ms, child: ItemWidget(items[i]))
/// ```
class ScrollReveal extends StatefulWidget {
  final Widget child;

  /// Extra delay before the animation starts after becoming visible.
  final Duration delay;

  /// Total animation duration.
  final Duration duration;

  /// Fraction of widget height to slide from (0.1 = 10 % below final pos).
  final double slideBeginY;

  /// Initial scale factor. 1.0 = no scale effect.
  final double scaleBegin;

  /// Visibility threshold before triggering (0.0–1.0).
  final double visibilityThreshold;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 650),
    this.slideBeginY = 0.12,
    this.scaleBegin = 1.0,
    this.visibilityThreshold = 0.08,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Key _detectorKey;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _detectorKey = UniqueKey();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_triggered && info.visibleFraction >= widget.visibilityThreshold) {
      _triggered = true;
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) _controller.forward();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final animated = widget.child
        .animate(controller: _controller, autoPlay: false)
        .fadeIn(duration: widget.duration, curve: Curves.easeOut)
        .slideY(
          begin: widget.slideBeginY,
          end: 0,
          duration: widget.duration,
          curve: Curves.easeOutCubic,
        );

    // Add scale effect only when requested
    final withScale = widget.scaleBegin < 1.0
        ? animated.scale(
            begin: Offset(widget.scaleBegin, widget.scaleBegin),
            end: const Offset(1.0, 1.0),
            duration: widget.duration,
            curve: Curves.easeOutCubic,
          )
        : animated;

    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: _onVisibilityChanged,
      child: withScale,
    );
  }
}

/// Convenience wrapper: animates children one by one with stagger.
///
/// ```dart
/// StaggerReveal(
///   stagger: 80.ms,
///   children: myWidgets,
/// )
/// ```
class StaggerReveal extends StatelessWidget {
  final List<Widget> children;
  final Duration stagger;
  final Duration duration;
  final double slideBeginY;

  const StaggerReveal({
    super.key,
    required this.children,
    this.stagger = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 600),
    this.slideBeginY = 0.12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++)
          ScrollReveal(
            delay: stagger * i,
            duration: duration,
            slideBeginY: slideBeginY,
            child: children[i],
          ),
      ],
    );
  }
}
