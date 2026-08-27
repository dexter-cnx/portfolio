import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/repository_status/data/datasources/repository_portfolio_status_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('loads repository-owned status metadata from raw GitHub', () async {
    final statusJson = jsonEncode({
      'schemaVersion': 1,
      'project': {
        'title': 'dxtr_box',
        'tagline': 'Local data layer',
        'status': 'active',
        'version': '0.8.0',
      },
      'summary': {'short': 'Short', 'long': 'Long'},
      'highlights': ['Fast'],
      'tech': ['Dart', 'Rust'],
      'links': {
        'repository': 'https://github.com/dexter-cnx/dxtr_box',
        'homepage': null,
        'package': null,
        'docs': null,
        'demo': null,
      },
      'updatedAt': '2026-08-27T00:00:00Z',
    });
    final client = MockClient((request) async {
      expect(request.url.host, 'raw.githubusercontent.com');
      expect(
        request.url.path,
        '/dexter-cnx/dxtr_box/main/.portfolio/status_th.json',
      );
      return http.Response(statusJson, 200);
    });
    final dataSource = RepositoryPortfolioStatusRemoteDataSourceImpl(
      client: client,
    );

    final status = await dataSource.load(
      repositoryFullName: 'dexter-cnx/dxtr_box',
      languageCode: 'th',
    );

    expect(status?.title, 'dxtr_box');
    expect(status?.tech, ['Dart', 'Rust']);
    expect(status?.updatedAt, DateTime.utc(2026, 8, 27));
  });

  test('falls back to master when main has no status metadata', () async {
    final requestedPaths = <String>[];
    final client = MockClient((request) async {
      requestedPaths.add(request.url.path);
      if (request.url.path.contains('/main/')) return http.Response('', 404);
      return http.Response(
        jsonEncode({
          'project': {'title': 'legacy'},
          'summary': {'short': 'Legacy status'},
        }),
        200,
      );
    });
    final dataSource = RepositoryPortfolioStatusRemoteDataSourceImpl(
      client: client,
    );

    final status = await dataSource.load(
      repositoryFullName: 'dexter-cnx/legacy',
      languageCode: 'en',
    );

    expect(status?.title, 'legacy');
    expect(requestedPaths, <String>[
      '/dexter-cnx/legacy/main/.portfolio/status_en.json',
      '/dexter-cnx/legacy/master/.portfolio/status_en.json',
    ]);
  });

  test('returns null when repository has no status metadata', () async {
    final dataSource = RepositoryPortfolioStatusRemoteDataSourceImpl(
      client: MockClient((_) async => http.Response('', 404)),
    );

    final status = await dataSource.load(
      repositoryFullName: 'dexter-cnx/example',
      languageCode: 'en',
    );

    expect(status, isNull);
  });
}
