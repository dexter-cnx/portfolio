import 'package:flutter/foundation.dart';

import '../../github_projects/domain/entities/github_project.dart';
import '../../github_projects/domain/repositories/github_project_repository.dart';
import '../domain/entities/portfolio_project_config.dart';
import '../domain/repositories/project_selection_store.dart';

enum ProjectSelectionStatus { initial, loading, ready, saving, error }

final class ProjectSelectionController extends ChangeNotifier {
  ProjectSelectionController({
    required GitHubProjectRepository githubRepository,
    required ProjectSelectionStore store,
  })  : _githubRepository = githubRepository,
        _store = store;

  final GitHubProjectRepository _githubRepository;
  final ProjectSelectionStore _store;

  ProjectSelectionStatus status = ProjectSelectionStatus.initial;
  List<GitHubProject> repositories = const <GitHubProject>[];
  ProjectSelectionConfig config = const ProjectSelectionConfig();
  String search = '';
  Object? error;

  List<GitHubProject> get filteredRepositories {
    final query = search.trim().toLowerCase();
    if (query.isEmpty) return repositories;
    return repositories
        .where((repo) =>
            repo.name.toLowerCase().contains(query) ||
            repo.description.toLowerCase().contains(query))
        .toList(growable: false);
  }

  Future<void> load() async {
    status = ProjectSelectionStatus.loading;
    error = null;
    notifyListeners();
    try {
      final results = await Future.wait<Object>([
        _githubRepository.loadPublicProjects(),
        _store.load(),
      ]);
      repositories = results[0] as List<GitHubProject>;
      config = results[1] as ProjectSelectionConfig;
      status = ProjectSelectionStatus.ready;
    } catch (exception) {
      error = exception;
      status = ProjectSelectionStatus.error;
    }
    notifyListeners();
  }

  void setSearch(String value) {
    search = value;
    notifyListeners();
  }

  void updateProject(
    int repositoryId, {
    bool? visible,
    bool? featured,
    bool? includeInPdf,
    int? sortOrder,
    String? titleOverride,
    String? summaryOverride,
  }) {
    final current = config.forRepository(repositoryId);
    config = config.replace(current.copyWith(
      visible: visible,
      featured: featured,
      includeInPdf: includeInPdf,
      sortOrder: sortOrder,
      titleOverride: titleOverride,
      summaryOverride: summaryOverride,
    ));
    notifyListeners();
  }

  Future<void> save() async {
    status = ProjectSelectionStatus.saving;
    error = null;
    notifyListeners();
    try {
      await _store.save(config);
      config = await _store.load();
      status = ProjectSelectionStatus.ready;
    } catch (exception) {
      error = exception;
      status = ProjectSelectionStatus.error;
    }
    notifyListeners();
  }
}
