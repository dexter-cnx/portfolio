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
    final uri = Uri.https(
      'api.github.com',
      '/repos/$repositoryFullName/contents/.portfolio/status_$locale.json',
    );
    final response = await _client.get(
      uri,
      headers: const {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      },
    );

    if (response.statusCode == 404) return null;
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw http.ClientException(
        'GitHub status request failed with ${response.statusCode}.',
        uri,
      );
    }

    final envelope = jsonDecode(response.body);
    if (envelope is! Map<String, dynamic>) {
      throw const FormatException(
        'GitHub contents response must be an object.',
      );
    }
    final encoded = envelope['content'];
    if (encoded is! String || encoded.isEmpty) {
      throw const FormatException('GitHub contents response has no content.');
    }

    final normalized = encoded.replaceAll('\n', '');
    final decoded = utf8.decode(base64Decode(normalized));
    final json = jsonDecode(decoded);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('Portfolio status must be a JSON object.');
    }
    return RepositoryPortfolioStatus.fromJson(json);
  }
}
