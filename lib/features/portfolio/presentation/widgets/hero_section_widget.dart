import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';

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
      child: Column(
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
                  fontSize: MediaQuery.sizeOf(context).width < 768 ? 32 : 64,
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
      ),
    );
  }
}
