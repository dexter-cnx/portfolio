import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

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
    return SectionWrapper(
      id: 'hero',
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
      child: ResponsiveLayout.isDesktop(context)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 3, child: _buildTextContent(context)),
                const SizedBox(width: 50),
                Expanded(flex: 2, child: _buildHeroImage(context)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildHeroImage(context)),
                const SizedBox(height: 50),
                _buildTextContent(context),
              ],
            ),
    );
  }

  Widget _buildTextContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hero.eyebrow,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppTheme.accent,
                fontSize: 16,
                letterSpacing: 1.5,
                fontFamily: 'JetBrains Mono',
              ),
        ),
        const SizedBox(height: 16),
        Text(
          hero.headline,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                height: 1.0,
                fontSize: MediaQuery.sizeOf(context).width < 768 ? 48 : 80,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          hero.subheadline,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppTheme.textMuted,
                height: 1.0,
                fontSize: MediaQuery.sizeOf(context).width < 768 ? 32 : 56,
              ),
        ),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            hero.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textMuted,
                  fontSize: 20,
                  height: 1.5,
                ),
          ),
        ),
        const SizedBox(height: 60),
        Row(
          children: [
            OutlinedButton(
              onPressed: () => onCtaTap(hero.primaryCta.url),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              ),
              child: Text(
                hero.primaryCta.label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 24),
            TextButton(
              onPressed: () => onCtaTap(hero.secondaryCta.url),
              child: Text(
                hero.secondaryCta.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.accent,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontFamily: 'JetBrains Mono',
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withValues(alpha: 0.2),
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/hero.png',
          width: ResponsiveLayout.isDesktop(context) ? 400 : 250,
          height: ResponsiveLayout.isDesktop(context) ? 400 : 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
