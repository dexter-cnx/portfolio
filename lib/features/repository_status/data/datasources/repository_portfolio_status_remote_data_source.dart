import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/repository_portfolio_status.dart';

abstract interface class RepositoryPortfolioStatusRemoteDataSource {
  Future<RepositoryPortfolioStatus?> load({
    required String repositoryFullName,
    required String languageCode,
  });
}

final class RepositoryPortfolioStatusRemoteDataSourceImpl
    implements RepositoryPortfolioStatusRemoteDataSource {
  RepositoryPortfolioStatusRemoteDataSourceImpl({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<RepositoryPortfolioStatus?> load({
    required String repositoryFullName,
    required String languageCode,
  }) async {
    final locale = languageCode == 'th' ? 'th' : 'en';
    final path = '.portfolio/status_$locale.json';

    for (final branch in const <String>['main', 'master']) {
      final uri = Uri.https(
        'raw.githubusercontent.com',
        '/$repositoryFullName/$branch/$path',
      );
      final response = await _client.get(uri);
      if (response.statusCode == 404) continue;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw http.ClientException(
          'GitHub raw status request failed with ${response.statusCode}.',
          uri,
        );
      }
      return _decode(response.body);
    }

    return null;
  }

  RepositoryPortfolioStatus _decode(String source) {
    final json = jsonDecode(source);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Portfolio status must be a JSON object.');
    }
    return RepositoryPortfolioStatus.fromJson(json);
  }
}
