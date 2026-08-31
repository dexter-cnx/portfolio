import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../data/datasources/local_content_loader.dart';
import '../../models/portfolio_data_with_export_selection.dart';
import '../../models/portfolio_models.dart';
import '../widgets/public_portfolio_shell.dart';
import 'project_detail_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final _loader = const LocalContentLoader();
  final _searchController = TextEditingController();
  String _query = '';
  String _filter = 'All';

  static const _filters = ['All', 'Flutter', 'Rust', 'Packages', 'Tools'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioData>(
      future: _loader.loadPortfolioData(context.locale.languageCode),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final catalog = _catalogProjects(data);
        final featured = _filteredFeatured(
          data.featuredProjects,
        ).toList(growable: false);
        final projects = _filteredOther(catalog).toList(growable: false);

        return PublicPortfolioShell(
          site: data.site,
          activeRoute: '/projects',
          child: SingleChildScrollView(
            child: PublicPageContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'projects_eyebrow'.tr(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 12),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Text(
                      'projects_headline'.tr(),
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: Text(
                      'projects_intro'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildControls(),
                  const SizedBox(height: 48),
                  if (featured.isNotEmpty) ...[
                    _SectionTitle(
                      eyebrow: 'projects_featured'.tr(),
                      title: 'projects_featured_title'.tr(),
                    ),
                    const SizedBox(height: 24),
                    ...featured.map(
                      (project) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _FeaturedProjectRow(
                          project: project,
                          onOpen: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  ProjectDetailPage(project: project),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 48),
                  _SectionTitle(
                    eyebrow: 'projects_catalog'.tr(),
                    title: 'projects_more'.tr(),
                  ),
                  const SizedBox(height: 24),
                  if (projects.isEmpty && featured.isEmpty)
                    _EmptyProjects(onReset: _resetFilters)
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 900
                            ? 3
                            : constraints.maxWidth >= 620
                            ? 2
                            : 1;
                        const gap = 16.0;
                        final width =
                            (constraints.maxWidth - gap * (columns - 1)) /
                            columns;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: projects
                              .map(
                                (project) => SizedBox(
                                  width: width,
                                  child: _ProjectCard(project: project),
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

  List<OtherProject> _catalogProjects(PortfolioData data) {
    final merged = <OtherProject>[...data.otherProjects];
    if (data is PortfolioDataWithExportSelection) {
      final knownRepos = merged.map((project) => project.repoUrl).toSet();
      for (final project in data.openSourceProjects) {
        if (project.repoUrl.isEmpty || knownRepos.add(project.repoUrl)) {
          merged.add(project);
        }
      }
    }
    return merged;
  }

  Widget _buildControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) =>
              setState(() => _query = value.trim().toLowerCase()),
          decoration: InputDecoration(
            hintText: 'projects_search'.tr(),
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.outline),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppTheme.outline),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _filters
              .map(
                (filter) => ChoiceChip(
                  label: Text(
                    _filterLabel(filter),
                    style: TextStyle(
                      color: _filter == filter
                          ? Colors.white
                          : AppTheme.textMuted,
                    ),
                  ),
                  selected: _filter == filter,
                  selectedColor: AppTheme.accent,
                  checkmarkColor: Colors.white,
                  backgroundColor: Colors.white,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  String _filterLabel(String filter) => switch (filter) {
    'All' => 'projects_filter_all'.tr(),
    'Flutter' => 'projects_filter_flutter'.tr(),
    'Rust' => 'projects_filter_rust'.tr(),
    'Packages' => 'projects_filter_packages'.tr(),
    'Tools' => 'projects_filter_tools'.tr(),
    _ => filter,
  };

  Iterable<FeaturedProject> _filteredFeatured(List<FeaturedProject> projects) =>
      projects.where(
        (project) => _matches(project.name, project.summary, project.tags),
      );

  Iterable<OtherProject> _filteredOther(List<OtherProject> projects) =>
      projects.where(
        (project) => _matches(project.name, project.summary, project.tags),
      );

  bool _matches(String name, String summary, List<String> tags) {
    final haystack = '$name $summary ${tags.join(' ')}'.toLowerCase();
    if (_query.isNotEmpty && !haystack.contains(_query)) return false;
    if (_filter == 'All') return true;

    final tagsLower = tags.map((tag) => tag.toLowerCase()).toList();
    return switch (_filter) {
      'Flutter' => tagsLower.any(
        (tag) => tag.contains('flutter') || tag.contains('dart'),
      ),
      'Rust' => tagsLower.any((tag) => tag.contains('rust')),
      'Packages' =>
        haystack.contains('package') ||
            haystack.contains('library') ||
            haystack.contains('crate') ||
            haystack.contains('pub.dev') ||
            name.contains('_flutter') ||
            name.contains('_l10n') ||
            name.contains('report_suite'),
      'Tools' =>
        haystack.contains('tool') ||
            haystack.contains('cli') ||
            haystack.contains('developer') ||
            tagsLower.any((tag) => tag == 'gpui'),
      _ => true,
    };
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _filter = 'All';
    });
  }
}

class _SectionTitle extends StatelessWidget {
  final String eyebrow;
  final String title;

  const _SectionTitle({required this.eyebrow, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: AppTheme.metaText),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        const Divider(height: 1, color: AppTheme.outline),
      ],
    );
  }
}

class _FeaturedProjectRow extends StatelessWidget {
  final FeaturedProject project;
  final VoidCallback onOpen;

  const _FeaturedProjectRow({required this.project, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
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
              Text(
                'projects_featured'.tr(),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(project.summary, style: Theme.of(context).textTheme.bodyMedium),
          if (project.longDescription.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              project.longDescription,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: 20),
          PortfolioTagWrap(tags: project.tags),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: onOpen,
                child: Text('btn_view_case_study'.tr()),
              ),
              if (project.repoUrl.isNotEmpty)
                OutlinedButton(
                  onPressed: () => launchPortfolioUrl(project.repoUrl),
                  child: const Text('GitHub'),
                ),
              if (project.liveUrl.isNotEmpty)
                TextButton(
                  onPressed: () => launchPortfolioUrl(project.liveUrl),
                  child: Text('projects_live_product'.tr()),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final OtherProject project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        border: Border.all(color: AppTheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(project.name, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(project.summary, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 18),
          PortfolioTagWrap(tags: project.tags),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            children: [
              if (project.repoUrl.isNotEmpty)
                TextButton(
                  onPressed: () => launchPortfolioUrl(project.repoUrl),
                  child: const Text('GitHub →'),
                ),
              if (project.liveUrl.isNotEmpty)
                TextButton(
                  onPressed: () => launchPortfolioUrl(project.liveUrl),
                  child: Text('${'btn_open'.tr()} →'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  final VoidCallback onReset;

  const _EmptyProjects({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow,
        border: Border.all(color: AppTheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        children: [
          Text(
            'projects_no_match'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'projects_no_match_hint'.tr(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: onReset, child: Text('btn_reset_filters'.tr())),
        ],
      ),
    );
  }
}
