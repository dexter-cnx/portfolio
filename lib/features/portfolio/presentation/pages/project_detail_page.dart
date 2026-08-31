import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../data/datasources/local_content_loader.dart';
import '../../models/portfolio_models.dart';
import '../widgets/public_portfolio_shell.dart';

class ProjectDetailPage extends StatelessWidget {
  final FeaturedProject project;

  const ProjectDetailPage({super.key, required this.project});

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
          activeRoute: '/projects',
          child: SingleChildScrollView(
            child: PublicPageContainer(
              maxWidth: 880,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'case_eyebrow'.tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppTheme.metaText),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    project.summary,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  PortfolioTagWrap(tags: project.tags),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      if (project.repoUrl.isNotEmpty)
                        FilledButton(
                          onPressed: () => launchPortfolioUrl(project.repoUrl),
                          child: Text('btn_view_source'.tr()),
                        ),
                      if (project.liveUrl.isNotEmpty)
                        OutlinedButton(
                          onPressed: () => launchPortfolioUrl(project.liveUrl),
                          child: Text('btn_view_product'.tr()),
                        ),
                      ...project.urls.map(
                        (item) => TextButton(
                          onPressed: () => launchPortfolioUrl(item.url),
                          child: Text(
                            item.title.isEmpty
                                ? 'btn_open_link'.tr()
                                : item.title,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (project.images.isNotEmpty) ...[
                    const SizedBox(height: 48),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.outline),
                        ),
                        child: Image.asset(
                          project.images.first,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 56),
                  _CaseStudySection(
                    label: 'case_overview'.tr(),
                    title: 'case_overview_title'.tr(),
                    child: Text(
                      project.longDescription.isEmpty
                          ? project.summary
                          : project.longDescription,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'case_engineering'.tr(),
                    title: 'case_engineering_title'.tr(),
                    child: _EngineeringHighlights(tags: project.tags),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'case_architecture'.tr(),
                    title: 'case_architecture_title'.tr(),
                    child: const _ArchitectureDiagram(),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'case_stack'.tr(),
                    title: 'case_stack_title'.tr(),
                    child: _StackTable(tags: project.tags),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'case_tradeoffs'.tr(),
                    title: 'case_tradeoffs_title'.tr(),
                    child: Text(
                      'case_tradeoffs_body'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 56),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceLow,
                      border: Border.all(color: AppTheme.outline),
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runSpacing: 16,
                      children: [
                        Text(
                          'case_more'.tr(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        FilledButton(
                          onPressed: () => Navigator.of(
                            context,
                          ).pushReplacementNamed('/projects'),
                          child: Text('btn_back_projects'.tr()),
                        ),
                      ],
                    ),
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

class _CaseStudySection extends StatelessWidget {
  final String label;
  final String title;
  final Widget child;

  const _CaseStudySection({
    required this.label,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppTheme.metaText),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppTheme.outline),
        const SizedBox(height: 22),
        child,
      ],
    );
  }
}

class _EngineeringHighlights extends StatelessWidget {
  final List<String> tags;

  const _EngineeringHighlights({required this.tags});

  @override
  Widget build(BuildContext context) {
    final items = tags.isEmpty
        ? ['case_production_delivery'.tr(), 'case_cross_platform'.tr()]
        : tags
              .take(4)
              .map((tag) => '$tag ${'case_implementation'.tr()}')
              .toList(growable: false);
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: items
          .map(
            (item) => SizedBox(
              width: 390,
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppTheme.outline),
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: Text(
                  item,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _ArchitectureDiagram extends StatelessWidget {
  const _ArchitectureDiagram();

  @override
  Widget build(BuildContext context) {
    final layers = [
      'case_layer_presentation'.tr(),
      'case_layer_application'.tr(),
      'case_layer_platform'.tr(),
      'case_layer_data'.tr(),
    ];
    return Column(
      children: [
        for (var index = 0; index < layers.length; index++) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: index.isEven ? Colors.white : AppTheme.surfaceLow,
              border: Border.all(color: AppTheme.outline),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Text(
              layers[index],
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          if (index != layers.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Icon(
                Icons.arrow_downward,
                size: 18,
                color: AppTheme.metaText,
              ),
            ),
        ],
      ],
    );
  }
}

class _StackTable extends StatelessWidget {
  final List<String> tags;

  const _StackTable({required this.tags});

  @override
  Widget build(BuildContext context) {
    final stack = tags.isEmpty ? ['case_project_stack'.tr()] : tags;
    return Column(
      children: [
        for (var index = 0; index < stack.length; index++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.outline)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(
                    index == 0 ? 'case_primary'.tr() : 'case_supporting'.tr(),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    stack[index],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
