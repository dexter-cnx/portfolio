import '../../github_projects/domain/entities/github_project.dart';
import '../../github_projects/domain/repositories/github_project_repository.dart';
import '../../portfolio/models/portfolio_data_with_export_selection.dart';
import '../../portfolio/models/portfolio_models.dart';
import '../../project_selection/domain/entities/portfolio_project_config.dart';
import '../../project_selection/domain/repositories/project_selection_store.dart';
import '../data/datasources/repository_portfolio_status_remote_data_source.dart';
import '../domain/entities/repository_portfolio_status.dart';

final class PortfolioProjectsLoader {
  const PortfolioProjectsLoader({
    required this.githubRepository,
    required this.selectionStore,
    required this.statusDataSource,
  });

  final GitHubProjectRepository githubRepository;
  final ProjectSelectionStore selectionStore;
  final RepositoryPortfolioStatusRemoteDataSource statusDataSource;

  Future<PortfolioData> enrich(
    PortfolioData fallback, {
    required String languageCode,
  }) async {
    try {
      final results = await Future.wait<Object>([
        githubRepository.loadPublicProjects(),
        selectionStore.load(),
      ]);
      final repositories = results[0] as List<GitHubProject>;
      final selection = results[1] as ProjectSelectionConfig;
      final selected = selection.projects.where((item) => item.visible).toList()
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

      if (selected.isEmpty) return fallback;

      final byId = {for (final repo in repositories) repo.id: repo};
      final featured = <FeaturedProject>[];
      final other = <OtherProject>[];
      final pdfProjectRepositoryUrls = <String>{};

      for (final config in selected) {
        final repository = byId[config.repositoryId];
        if (repository == null) continue;
        final status = await _loadStatus(repository, languageCode);
        final project = _compose(repository, config, status);
        final repositoryUrl = project.$1.repoUrl.isNotEmpty
            ? project.$1.repoUrl
            : project.$2.repoUrl;
        if (config.includeInPdf && repositoryUrl.isNotEmpty) {
          pdfProjectRepositoryUrls.add(repositoryUrl);
        }
        if (config.featured) {
          featured.add(project.$1);
        } else {
          other.add(project.$2);
        }
      }

      if (featured.isEmpty && other.isEmpty) return fallback;
      return PortfolioDataWithExportSelection(
        site: fallback.site,
        hero: fallback.hero,
        about: fallback.about,
        experience: fallback.experience,
        featuredProjects: featured,
        otherProjects: other,
        contact: fallback.contact,
        socialLinks: fallback.socialLinks,
        nav: fallback.nav,
        pdfProjectRepositoryUrls: pdfProjectRepositoryUrls,
      );
    } catch (_) {
      return fallback;
    }
  }

  Future<RepositoryPortfolioStatus?> _loadStatus(
    GitHubProject repository,
    String languageCode,
  ) async {
    try {
      return await statusDataSource.load(
        repositoryFullName: repository.fullName,
        languageCode: languageCode,
      );
    } catch (_) {
      return null;
    }
  }

  (FeaturedProject, OtherProject) _compose(
    GitHubProject repository,
    PortfolioProjectConfig config,
    RepositoryPortfolioStatus? status,
  ) {
    final title = config.titleOverride.trim().isNotEmpty
        ? config.titleOverride.trim()
        : status?.title.trim().isNotEmpty == true
        ? status!.title.trim()
        : repository.name;
    final summary = config.summaryOverride.trim().isNotEmpty
        ? config.summaryOverride.trim()
        : status?.shortSummary.trim().isNotEmpty == true
        ? status!.shortSummary.trim()
        : repository.description;
    final repoUrl = status?.links.repository.isNotEmpty == true
        ? status!.links.repository
        : repository.htmlUrl;
    final liveUrl = _firstNonEmpty([
      status?.links.demo,
      status?.links.homepage,
      repository.homepageUrl,
    ]);
    final tags = status?.tech.isNotEmpty == true
        ? status!.tech
        : <String>[
            if (repository.language.isNotEmpty) repository.language,
            ...repository.topics,
          ];
    final urls = <ProjectUrl>[
      if (status?.links.package.isNotEmpty == true)
        ProjectUrl(image: '', title: 'Package', url: status!.links.package),
      if (status?.links.docs.isNotEmpty == true)
        ProjectUrl(image: '', title: 'Docs', url: status!.links.docs),
      if (status?.links.demo.isNotEmpty == true)
        ProjectUrl(image: '', title: 'Demo', url: status!.links.demo),
    ];

    return (
      FeaturedProject(
        name: title,
        summary: summary,
        longDescription: status?.longSummary ?? '',
        repoUrl: repoUrl,
        liveUrl: liveUrl,
        images: const [],
        urls: urls,
        tags: tags,
      ),
      OtherProject(
        name: title,
        summary: summary,
        repoUrl: repoUrl,
        liveUrl: liveUrl,
        images: const [],
        tags: tags,
      ),
    );
  }

  String _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) return value.trim();
    }
    return '';
  }
}
