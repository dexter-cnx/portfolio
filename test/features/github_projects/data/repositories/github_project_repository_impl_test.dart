import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/github_projects/data/datasources/github_project_remote_data_source.dart';
import 'package:flutter_web_portfolio_starter/features/github_projects/data/models/github_project_model.dart';
import 'package:flutter_web_portfolio_starter/features/github_projects/data/repositories/github_project_repository_impl.dart';
import 'package:flutter_web_portfolio_starter/features/github_projects/domain/repositories/github_project_repository.dart';

void main() {
  test(
    'filters archived and fork repositories by default and sorts by push date',
    () async {
      final dataSource = _FakeRemoteDataSource(<GitHubProjectModel>[
        _project(id: 1, name: 'old', pushedAt: DateTime.utc(2026, 1)),
        _project(id: 2, name: 'new', pushedAt: DateTime.utc(2026, 3)),
        _project(id: 3, name: 'archived', archived: true),
        _project(id: 4, name: 'fork', isFork: true),
      ]);
      final repository = GitHubProjectRepositoryImpl(
        owner: 'dexter-cnx',
        remoteDataSource: dataSource,
      );

      final projects = await repository.loadPublicProjects();

      expect(projects.map((project) => project.name), <String>['new', 'old']);
    },
  );

  test('keeps repositories without push dates last when descending', () async {
    final dataSource = _FakeRemoteDataSource(<GitHubProjectModel>[
      _project(id: 1, name: 'never-pushed', neverPushed: true),
      _project(id: 2, name: 'recent', pushedAt: DateTime.utc(2026, 8)),
      _project(id: 3, name: 'older', pushedAt: DateTime.utc(2026, 4)),
    ]);
    final repository = GitHubProjectRepositoryImpl(
      owner: 'dexter-cnx',
      remoteDataSource: dataSource,
    );

    final projects = await repository.loadPublicProjects();

    expect(
      projects.map((project) => project.name),
      <String>['recent', 'older', 'never-pushed'],
    );
  });

  test('can explicitly include archived and fork repositories', () async {
    final dataSource = _FakeRemoteDataSource(<GitHubProjectModel>[
      _project(id: 1, name: 'main'),
      _project(id: 2, name: 'archived', archived: true),
      _project(id: 3, name: 'fork', isFork: true),
    ]);
    final repository = GitHubProjectRepositoryImpl(
      owner: 'dexter-cnx',
      remoteDataSource: dataSource,
    );

    final projects = await repository.loadPublicProjects(
      query: const GitHubProjectQuery(
        includeArchived: true,
        includeForks: true,
        sort: GitHubProjectSort.name,
        descending: false,
      ),
    );

    expect(
      projects.map((project) => project.name),
      <String>['archived', 'fork', 'main'],
    );
  });

  test('reuses fresh cached repository data until force refresh', () async {
    final now = DateTime.utc(2026, 8, 27, 7);
    final dataSource = _FakeRemoteDataSource(<GitHubProjectModel>[
      _project(id: 1, name: 'cached'),
    ]);
    final repository = GitHubProjectRepositoryImpl(
      owner: 'dexter-cnx',
      remoteDataSource: dataSource,
      now: () => now,
    );

    await repository.loadPublicProjects();
    await repository.loadPublicProjects();
    expect(dataSource.calls, 1);

    await repository.loadPublicProjects(forceRefresh: true);
    expect(dataSource.calls, 2);
  });
}

GitHubProjectModel _project({
  required int id,
  required String name,
  DateTime? pushedAt,
  bool neverPushed = false,
  bool archived = false,
  bool isFork = false,
}) {
  return GitHubProjectModel(
    id: id,
    ownerLogin: 'dexter-cnx',
    name: name,
    fullName: 'dexter-cnx/$name',
    description: '',
    htmlUrl: 'https://github.com/dexter-cnx/$name',
    homepageUrl: '',
    language: 'Dart',
    topics: const <String>[],
    stars: 0,
    forks: 0,
    archived: archived,
    isFork: isFork,
    createdAt: DateTime.utc(2025),
    updatedAt: pushedAt ?? DateTime.utc(2026, 1),
    pushedAt: neverPushed ? null : pushedAt ?? DateTime.utc(2026, 1),
    licenseSpdxId: 'MIT',
  );
}

final class _FakeRemoteDataSource implements GitHubProjectRemoteDataSource {
  _FakeRemoteDataSource(this.projects);

  final List<GitHubProjectModel> projects;
  int calls = 0;

  @override
  Future<List<GitHubProjectModel>> fetchPublicRepositories({
    required String owner,
    int perPage = 100,
    int maxPages = 10,
  }) async {
    calls += 1;
    return projects;
  }
}
