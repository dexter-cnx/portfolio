import '../entities/github_project.dart';

enum GitHubProjectSort { pushedAt, updatedAt, stars, name }

final class GitHubProjectQuery {
  const GitHubProjectQuery({
    this.includeArchived = false,
    this.includeForks = false,
    this.sort = GitHubProjectSort.pushedAt,
    this.descending = true,
    this.perPage = 100,
    this.maxPages = 10,
  });

  final bool includeArchived;
  final bool includeForks;
  final GitHubProjectSort sort;
  final bool descending;
  final int perPage;
  final int maxPages;
}

abstract interface class GitHubProjectRepository {
  Future<List<GitHubProject>> loadPublicProjects({
    GitHubProjectQuery query = const GitHubProjectQuery(),
    bool forceRefresh = false,
  });

  void clearCache();
}
