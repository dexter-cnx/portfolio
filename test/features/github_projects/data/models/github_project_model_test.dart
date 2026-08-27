import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/github_projects/data/models/github_project_model.dart';

void main() {
  test('maps GitHub repository JSON into normalized entity', () {
    final model = GitHubProjectModel.fromJson(<String, dynamic>{
      'id': 42,
      'owner': <String, dynamic>{'login': 'dexter-cnx'},
      'name': 'sample',
      'full_name': 'dexter-cnx/sample',
      'description': null,
      'html_url': 'https://github.com/dexter-cnx/sample',
      'homepage': null,
      'language': 'Dart',
      'topics': <String>['flutter', 'portfolio'],
      'stargazers_count': 12,
      'forks_count': 3,
      'archived': false,
      'fork': false,
      'created_at': '2026-01-01T00:00:00Z',
      'updated_at': '2026-02-01T00:00:00Z',
      'pushed_at': '2026-03-01T00:00:00Z',
      'license': <String, dynamic>{'spdx_id': 'MIT'},
    });

    final project = model.toEntity();

    expect(project.id, 42);
    expect(project.ownerLogin, 'dexter-cnx');
    expect(project.description, isEmpty);
    expect(project.homepageUrl, isEmpty);
    expect(project.topics, <String>['flutter', 'portfolio']);
    expect(project.stars, 12);
    expect(project.forks, 3);
    expect(project.pushedAt, DateTime.utc(2026, 3));
    expect(project.licenseSpdxId, 'MIT');
  });
}
