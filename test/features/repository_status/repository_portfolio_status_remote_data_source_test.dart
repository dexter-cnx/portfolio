import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_web_portfolio_starter/features/repository_status/data/datasources/repository_portfolio_status_remote_data_source.dart';

void main() {
  test('loads and decodes repository-owned status metadata', () async {
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
      expect(
        request.url.path,
        '/repos/dexter-cnx/dxtr_box/contents/.portfolio/status_th.json',
      );
      return http.Response(
        jsonEncode({'content': base64Encode(utf8.encode(statusJson))}),
        200,
      );
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
