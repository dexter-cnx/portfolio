import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../data/datasources/local_content_loader.dart';
import '../../models/portfolio_models.dart';
import '../widgets/public_portfolio_shell.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final loader = const LocalContentLoader();
    return FutureBuilder<PortfolioData>(
      future: loader.loadPortfolioData(context.locale.languageCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final data = snapshot.data!;
        return PublicPortfolioShell(
          site: data.site,
          activeRoute: '/experience',
          child: SingleChildScrollView(
            child: PublicPageContainer(
              maxWidth: 920,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPERIENCE',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Engineering across multiple generations of mobile software.',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Selected companies and products, with company names kept directly scannable and technical impact separated from general responsibilities.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  const Divider(height: 1, color: AppTheme.outline),
                  ...data.experience.map(
                    (experience) => _ExperienceEntry(experience: experience),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ExperienceEntry extends StatelessWidget {
  final Experience experience;

  const _ExperienceEntry({required this.experience});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    final company = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(experience.company, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          experience.title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary),
        ),
        const SizedBox(height: 4),
        Text(experience.period, style: Theme.of(context).textTheme.labelMedium),
      ],
    );

    final impact = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (experience.summary.isNotEmpty)
          Text(
            experience.summary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        if (experience.highlights.isNotEmpty) ...[
          const SizedBox(height: 12),
          ...experience.highlights.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 8, right: 10),
                    child: SizedBox(
                      width: 4,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppTheme.metaText,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        if (experience.tech.isNotEmpty) ...[
          const SizedBox(height: 14),
          PortfolioTagWrap(tags: experience.tech),
        ],
        if (experience.url.isNotEmpty) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => launchPortfolioUrl(experience.url),
            child: const Text('Company / Product →'),
          ),
        ],
      ],
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.outline)),
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 290, child: company),
                const SizedBox(width: 36),
                Expanded(child: impact),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [company, const SizedBox(height: 18), impact],
            ),
    );
  }
}
