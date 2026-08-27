import '../../domain/entities/github_project.dart';
import '../../domain/repositories/github_project_repository.dart';
import '../datasources/github_project_remote_data_source.dart';

final class GitHubProjectRepositoryImpl implements GitHubProjectRepository {
  GitHubProjectRepositoryImpl({
    required String owner,
    required GitHubProjectRemoteDataSource remoteDataSource,
    this.cacheTtl = const Duration(minutes: 15),
    DateTime Function()? now,
  })  : _owner = owner,
        _remoteDataSource = remoteDataSource,
        _now = now ?? DateTime.now;

  final String _owner;
  final GitHubProjectRemoteDataSource _remoteDataSource;
  final Duration cacheTtl;
  final DateTime Function() _now;
  final Map<String, _CacheEntry> _cache = <String, _CacheEntry>{};

  @override
  Future<List<GitHubProject>> loadPublicProjects({
    GitHubProjectQuery query = const GitHubProjectQuery(),
    bool forceRefresh = false,
  }) async {
    final cacheKey = '${query.perPage}:${query.maxPages}';
    final cached = _cache[cacheKey];
    final isFresh = cached != null &&
        _now().difference(cached.cachedAt) >= Duration.zero &&
        _now().difference(cached.cachedAt) < cacheTtl;

    late final List<GitHubProject> allProjects;
    if (!forceRefresh && isFresh) {
      allProjects = cached.projects;
    } else {
      final models = await _remoteDataSource.fetchPublicRepositories(
        owner: _owner,
        perPage: query.perPage,
        maxPages: query.maxPages,
      );
      allProjects = models.map((model) => model.toEntity()).toList(growable: false);
      _cache[cacheKey] = _CacheEntry(
        cachedAt: _now(),
        projects: allProjects,
      );
    }

    final filtered = allProjects.where((project) {
      if (!query.includeArchived && project.archived) return false;
      if (!query.includeForks && project.isFork) return false;
      return true;
    }).toList(growable: true);

    filtered.sort((left, right) {
      final result = switch (query.sort) {
        GitHubProjectSort.pushedAt => _compareDate(left.pushedAt, right.pushedAt),
        GitHubProjectSort.updatedAt => _compareDate(left.updatedAt, right.updatedAt),
        GitHubProjectSort.stars => left.stars.compareTo(right.stars),
        GitHubProjectSort.name => left.name.toLowerCase().compareTo(
              right.name.toLowerCase(),
            ),
      };
      return query.descending ? -result : result;
    });

    return List<GitHubProject>.unmodifiable(filtered);
  }

  @override
  void clearCache() => _cache.clear();

  static int _compareDate(DateTime? left, DateTime? right) {
    if (left == null && right == null) return 0;
    if (left == null) return -1;
    if (right == null) return 1;
    return left.compareTo(right);
  }
}

final class _CacheEntry {
  const _CacheEntry({required this.cachedAt, required this.projects});

  final DateTime cachedAt;
  final List<GitHubProject> projects;
}
