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
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                  Text('ENGINEERING CASE STUDY', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.metaText)),
                  const SizedBox(height: 14),
                  Text(project.name, style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 16),
                  Text(project.summary, style: Theme.of(context).textTheme.bodyLarge),
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
                          child: const Text('View Source'),
                        ),
                      if (project.liveUrl.isNotEmpty)
                        OutlinedButton(
                          onPressed: () => launchPortfolioUrl(project.liveUrl),
                          child: const Text('View Product'),
                        ),
                      ...project.urls.map(
                        (item) => TextButton(
                          onPressed: () => launchPortfolioUrl(item.url),
                          child: Text(item.title.isEmpty ? 'Open link' : item.title),
                        ),
                      ),
                    ],
                  ),
                  if (project.images.isNotEmpty) ...[
                    const SizedBox(height: 48),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: AppTheme.outline)),
                        child: Image.asset(project.images.first, fit: BoxFit.cover),
                      ),
                    ),
                  ],
                  const SizedBox(height: 56),
                  _CaseStudySection(
                    label: 'OVERVIEW',
                    title: 'What this project is',
                    child: Text(
                      project.longDescription.isEmpty ? project.summary : project.longDescription,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'ENGINEERING APPROACH',
                    title: 'Technical foundation',
                    child: _EngineeringHighlights(tags: project.tags),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'ARCHITECTURE',
                    title: 'Responsibility-driven layers',
                    child: const _ArchitectureDiagram(),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'TECHNICAL STACK',
                    title: 'Technologies by responsibility',
                    child: _StackTable(tags: project.tags),
                  ),
                  const SizedBox(height: 48),
                  _CaseStudySection(
                    label: 'TRADE-OFFS',
                    title: 'Engineering decisions',
                    child: Text(
                      'This portfolio only presents decisions supported by the project data. Detailed problem, decision, trade-off, performance, and evidence fields can be added through the structured case-study model without inventing claims.',
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
                        Text('Explore more engineering work.', style: Theme.of(context).textTheme.titleLarge),
                        FilledButton(
                          onPressed: () => Navigator.of(context).pushReplacementNamed('/projects'),
                          child: const Text('Back to Projects'),
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

  const _CaseStudySection({required this.label, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.metaText)),
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
        ? const ['Production delivery', 'Cross-platform implementation']
        : tags.take(4).map((tag) => '$tag implementation').toList(growable: false);
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
                child: Text(item, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary)),
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
    const layers = ['Presentation / Client', 'Application & Domain', 'Platform / Service Boundary', 'Data & External Services'];
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
            child: Text(layers[index], textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelLarge),
          ),
          if (index != layers.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Icon(Icons.arrow_downward, size: 18, color: AppTheme.metaText),
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
    final stack = tags.isEmpty ? const ['Project-specific stack'] : tags;
    return Column(
      children: [
        for (var index = 0; index < stack.length; index++)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.outline))),
            child: Row(
              children: [
                SizedBox(
                  width: 130,
                  child: Text(index == 0 ? 'Primary' : 'Supporting', style: Theme.of(context).textTheme.labelMedium),
                ),
                Expanded(child: Text(stack[index], style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textPrimary))),
              ],
            ),
          ),
      ],
    );
  }
}
