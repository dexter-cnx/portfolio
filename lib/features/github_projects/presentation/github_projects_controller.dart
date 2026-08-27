import 'package:flutter/foundation.dart';

import '../domain/entities/github_project.dart';
import '../domain/repositories/github_project_repository.dart';

enum GitHubProjectsStatus { initial, loading, success, empty, error }

final class GitHubProjectsController extends ChangeNotifier {
  GitHubProjectsController({required GitHubProjectRepository repository})
    : _repository = repository;

  final GitHubProjectRepository _repository;
  int _requestGeneration = 0;

  GitHubProjectsStatus status = GitHubProjectsStatus.initial;
  List<GitHubProject> projects = const <GitHubProject>[];
  Object? error;

  Future<void> load({
    GitHubProjectQuery query = const GitHubProjectQuery(),
    bool forceRefresh = false,
  }) async {
    final requestGeneration = ++_requestGeneration;
    status = GitHubProjectsStatus.loading;
    error = null;
    notifyListeners();

    try {
      final result = await _repository.loadPublicProjects(
        query: query,
        forceRefresh: forceRefresh,
      );
      if (requestGeneration != _requestGeneration) return;

      projects = result;
      status = result.isEmpty
          ? GitHubProjectsStatus.empty
          : GitHubProjectsStatus.success;
    } catch (exception) {
      if (requestGeneration != _requestGeneration) return;

      projects = const <GitHubProject>[];
      error = exception;
      status = GitHubProjectsStatus.error;
    }

    notifyListeners();
  }
}
