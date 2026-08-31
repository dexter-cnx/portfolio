import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../data/datasources/local_content_loader.dart';
import '../../models/portfolio_data_with_export_selection.dart';
import '../../models/portfolio_models.dart';
import '../widgets/public_portfolio_shell.dart';

class OpenSourcePage extends StatelessWidget {
  const OpenSourcePage({super.key});

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
        final projects = data is PortfolioDataWithExportSelection
            ? data.openSourceProjects
            : const <OtherProject>[];
        return PublicPortfolioShell(
          site: data.site,
          activeRoute: '/open-source',
          child: SingleChildScrollView(
            child: PublicPageContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'open_source_eyebrow'.tr(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'open_source_headline'.tr(),
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'open_source_intro'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 40),
                  const Divider(height: 1, color: AppTheme.outline),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.maxWidth >= 850
                          ? 3
                          : constraints.maxWidth >= 560
                          ? 2
                          : 1;
                      const gap = 16.0;
                      final width =
                          (constraints.maxWidth - gap * (columns - 1)) /
                          columns;
                      if (projects.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLow,
                            border: Border.all(color: AppTheme.outline),
                            borderRadius: BorderRadius.circular(
                              AppTheme.cardRadius,
                            ),
                          ),
                          child: Text(
                            'open_source_empty'.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      return Wrap(
                        spacing: gap,
                        runSpacing: gap,
                        children: projects
                            .map(
                              (project) => SizedBox(
                                width: width,
                                child: _OpenSourceCard(project: project),
                              ),
                            )
                            .toList(growable: false),
                      );
                    },
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

class _OpenSourceCard extends StatelessWidget {
  final OtherProject project;

  const _OpenSourceCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final registry = _registryLabel(project);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppTheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              if (registry != null)
                Text(registry, style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(project.summary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          PortfolioTagWrap(tags: project.tags),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            children: [
              if (project.liveUrl.isNotEmpty)
                TextButton(
                  onPressed: () => launchPortfolioUrl(project.liveUrl),
                  child: Text(
                    registry == null ? '${'btn_open'.tr()} →' : '$registry →',
                  ),
                ),
              if (project.repoUrl.isNotEmpty)
                TextButton(
                  onPressed: () => launchPortfolioUrl(project.repoUrl),
                  child: const Text('GitHub →'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String? _registryLabel(OtherProject project) {
    final url = project.liveUrl.toLowerCase();
    if (url.contains('pub.dev')) return 'pub.dev';
    if (url.contains('crates.io')) return 'crates.io';
    return null;
  }
}
