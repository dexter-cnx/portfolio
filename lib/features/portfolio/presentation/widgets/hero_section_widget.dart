import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
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

    return Cue.onMount(
      motion: const Spring.smooth(),
      child: SectionWrapper(
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
                  Expanded(
                    flex: 2,
                    child: Actor(
                      delay: const Duration(milliseconds: 300),
                      acts: [
                        Act.fadeIn(),
                        Act.scale(from: 0.88),
                      ],
                      child: _buildHeroImage(context),
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Actor(
                      delay: const Duration(milliseconds: 300),
                      acts: [
                        Act.fadeIn(),
                        Act.scale(from: 0.88),
                      ],
                      child: _buildHeroImage(context),
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildTextContent(context),
                ],
              ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Eyebrow ─────────────────────────────────────────────
        Actor(
          delay: const Duration(milliseconds: 100),
          acts: [
            Act.fadeIn(),
            Act.slideY(from: 0.15),
          ],
          child: Text(
            hero.eyebrow,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.accent,
                  fontSize: 14,
                  letterSpacing: 2.0,
                  fontFamily: 'JetBrains Mono',
                ),
          ),
        ),

        const SizedBox(height: 16),

        // ── Headline ─────────────────────────────────────────────
        Actor(
          delay: const Duration(milliseconds: 200),
          acts: [
            Act.fadeIn(),
            Act.slideY(from: 0.12),
          ],
          child: Text(
            hero.headline,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  height: 1.05,
                  fontSize: context.heroFontSize,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),

        const SizedBox(height: 8),

        // ── Subheadline ───────────────────────────────────────────
        Actor(
          delay: const Duration(milliseconds: 350),
          acts: [
            Act.fadeIn(),
            Act.slideY(from: 0.12),
          ],
          child: Text(
            hero.subheadline,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppTheme.textMuted,
                  height: 1.05,
                  fontSize: context.heroFontSize * 0.7,
                ),
          ),
        ),

        const SizedBox(height: 32),

        // ── Description ───────────────────────────────────────────
        Actor(
          delay: const Duration(milliseconds: 500),
          acts: [
            Act.fadeIn(),
            Act.slideY(from: 0.08),
          ],
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              hero.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 18,
                    height: 1.6,
                  ),
            ),
          ),
        ),

        const SizedBox(height: 56),

        // ── CTAs ──────────────────────────────────────────────────
        Wrap(
          spacing: 20,
          runSpacing: 16,
          children: [
            Actor(
              delay: const Duration(milliseconds: 700),
              acts: [
                Act.fadeIn(),
                Act.slideX(from: -0.1),
              ],
              child: OutlinedButton(
                onPressed: () => onCtaTap(hero.primaryCta.url),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(fontSize: 15),
                ),
                child: Text(hero.primaryCta.label),
              ),
            ),
            Actor(
              delay: const Duration(milliseconds: 850),
              acts: [
                Act.fadeIn(),
                Act.slideX(from: -0.1),
              ],
              child: TextButton.icon(
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
              ),
            ),
          ],
        ),

        const SizedBox(height: 80),

        // ── Scroll prompt ─────────────────────────────────────────
        Actor(
          delay: const Duration(milliseconds: 1100),
          acts: const [Act.fadeIn()],
          child: _ScrollPrompt(),
        ),
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
