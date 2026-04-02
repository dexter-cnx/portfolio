import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_wrapper.dart';

class HeroSectionWidget extends StatelessWidget {
  final HeroSection hero;

  const HeroSectionWidget({super.key, required this.hero});

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
                ),
          ),
          const SizedBox(height: 16),
          Text(
            hero.headline,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  height: 1.0,
                  fontSize: MediaQuery.sizeOf(context).width < 768 ? 48 : 72,
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
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Text(
              hero.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textMuted,
                    fontSize: 18,
                  ),
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                child: Text(hero.primaryCta.label),
              ),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () {},
                child: Text(
                  hero.secondaryCta.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.accent,
                        decoration: TextDecoration.underline,
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
