import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

/// Hero section with Cue.onMount-style staggered entry animations.
///
/// Each element fades + slides up sequentially, giving the impression
/// the page assembles itself on first load.
class HeroSectionWidget extends StatelessWidget {
  final HeroSection hero;
  final Function(String url) onCtaTap;

  const HeroSectionWidget({
    super.key,
    required this.hero,
    required this.onCtaTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extra top padding to clear the transparent glass navbar
    final topPad = context.responsive(mobile: 110.0, desktop: 140.0);

    return SectionWrapper(
      id: 'hero',
      padding: EdgeInsets.only(
        top: topPad,
        bottom: 120,
        left: context.sectionPaddingH,
        right: context.sectionPaddingH,
      ),
      child: ResponsiveLayout.isDesktop(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: _buildTextContent(context)),
                const SizedBox(width: 60),
                Expanded(flex: 2, child: _buildHeroImage(context)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildHeroImage(context)),
                const SizedBox(height: 48),
                _buildTextContent(context),
              ],
            ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    const curve = Curves.easeOutCubic;
    const slideDuration = Duration(milliseconds: 700);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Eyebrow ─────────────────────────────────────────────
        Text(
          hero.eyebrow,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.accent,
                fontSize: 14,
                letterSpacing: 2.0,
                fontFamily: 'JetBrains Mono',
              ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms, curve: curve)
            .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: 100.ms, curve: curve),

        const SizedBox(height: 16),

        // ── Headline ─────────────────────────────────────────────
        Text(
          hero.headline,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                height: 1.05,
                fontSize: context.heroFontSize,
                fontWeight: FontWeight.w800,
              ),
        )
            .animate()
            .fadeIn(duration: slideDuration, delay: 200.ms, curve: curve)
            .slideY(begin: 0.12, end: 0, duration: slideDuration, delay: 200.ms, curve: curve),

        const SizedBox(height: 8),

        // ── Subheadline ───────────────────────────────────────────
        Text(
          hero.subheadline,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.textMuted,
                height: 1.05,
                fontSize: context.heroFontSize * 0.7,
              ),
        )
            .animate()
            .fadeIn(duration: slideDuration, delay: 350.ms, curve: curve)
            .slideY(begin: 0.12, end: 0, duration: slideDuration, delay: 350.ms, curve: curve),

        const SizedBox(height: 32),

        // ── Description ───────────────────────────────────────────
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            hero.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textMuted,
                  fontSize: 18,
                  height: 1.6,
                ),
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms, curve: Curves.easeOut),

        const SizedBox(height: 56),

        // ── CTAs ──────────────────────────────────────────────────
        Wrap(
          spacing: 20,
          runSpacing: 16,
          children: [
            OutlinedButton(
              onPressed: () => onCtaTap(hero.primaryCta.url),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                textStyle: const TextStyle(fontSize: 15),
              ),
              child: Text(hero.primaryCta.label),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 700.ms, curve: curve)
                .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 700.ms, curve: curve),

            TextButton.icon(
              onPressed: () => onCtaTap(hero.secondaryCta.url),
              icon: const Icon(
                Icons.arrow_forward,
                size: 16,
                color: AppTheme.accent,
              ),
              label: Text(
                hero.secondaryCta.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accent,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      fontFamily: 'JetBrains Mono',
                    ),
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 850.ms, curve: curve)
                .slideX(begin: -0.1, end: 0, duration: 500.ms, delay: 850.ms, curve: curve),
          ],
        ),

        const SizedBox(height: 80),

        // ── Scroll prompt ─────────────────────────────────────────
        _ScrollPrompt()
            .animate()
            .fadeIn(duration: 600.ms, delay: 1100.ms, curve: Curves.easeOut),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final size = context.isDesktop ? 380.0 : 220.0;

    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.accent.withValues(alpha: 0.25),
              blurRadius: 80,
              spreadRadius: 8,
            ),
            BoxShadow(
              color: AppTheme.accent.withValues(alpha: 0.08),
              blurRadius: 160,
              spreadRadius: 20,
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/images/hero.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: 300.ms, curve: Curves.easeOut)
        .scale(
          begin: const Offset(0.88, 0.88),
          end: const Offset(1.0, 1.0),
          duration: 800.ms,
          delay: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

// ── Scroll prompt ───────────────────────────────────────────────────────────

class _ScrollPrompt extends StatefulWidget {
  @override
  State<_ScrollPrompt> createState() => _ScrollPromptState();
}

class _ScrollPromptState extends State<_ScrollPrompt>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _bounce.value),
        child: Column(
          children: [
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppTheme.textMuted.withValues(alpha: 0.6),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
