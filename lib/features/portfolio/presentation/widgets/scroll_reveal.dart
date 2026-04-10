import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
import 'portfolio_motion.dart';

/// Plays a fade + slide-up + optional scale animation the first time
/// the widget becomes visible.
///
/// This is the Cue-backed replacement for the previous custom
/// visibility-detector + flutter_animate implementation.
class ScrollReveal extends StatelessWidget {
  final Widget child;

  /// Extra delay before the animation starts after becoming visible.
  final Duration delay;

  /// Fraction of widget height to slide from (0.1 = 10 % below final pos).
  final double slideBeginY;

  /// Initial scale factor. 1.0 = no scale effect.
  final double scaleBegin;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.slideBeginY = kContentRevealSlideFrom,
    this.scaleBegin = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final acts = <Act>[
      Act.fadeIn(delay: delay, motion: const Spring.smooth()),
      Act.slideY(
        from: slideBeginY,
        motion: const Spring.smooth(),
        delay: delay,
      ),
      if (scaleBegin < 1.0)
        Act.scale(
          from: scaleBegin,
          to: 1.0,
          motion: const Spring.smooth(),
          delay: delay,
        ),
    ];

    return Cue.onScrollVisible(acts: acts, child: child);
  }
}

/// Convenience wrapper: animates children one by one with stagger.
class StaggerReveal extends StatelessWidget {
  final List<Widget> children;
  final Duration stagger;
  final double slideBeginY;

  const StaggerReveal({
    super.key,
    required this.children,
    this.stagger = kProjectOtherCardStagger,
    this.slideBeginY = kContentRevealSlideFrom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < children.length; i++)
          ScrollReveal(
            delay: stagger * i,
            slideBeginY: slideBeginY,
            child: children[i],
          ),
      ],
    );
  }
}
