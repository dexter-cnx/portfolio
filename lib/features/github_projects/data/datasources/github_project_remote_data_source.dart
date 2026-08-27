import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/github_project_model.dart';

final class GitHubProjectsException implements Exception {
  const GitHubProjectsException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'GitHubProjectsException($statusCode): $message';
}

abstract interface class GitHubProjectRemoteDataSource {
  Future<List<GitHubProjectModel>> fetchPublicRepositories({
    required String owner,
    int perPage = 100,
    int maxPages = 10,
  });
}

final class GitHubProjectRemoteDataSourceImpl
    implements GitHubProjectRemoteDataSource {
  GitHubProjectRemoteDataSourceImpl({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  @override
  Future<List<GitHubProjectModel>> fetchPublicRepositories({
    required String owner,
    int perPage = 100,
    int maxPages = 10,
  }) async {
    final safePerPage = perPage.clamp(1, 100);
    final safeMaxPages = maxPages < 1 ? 1 : maxPages;
    final repositories = <GitHubProjectModel>[];

    for (var page = 1; page <= safeMaxPages; page++) {
      final uri = Uri.https('api.github.com', '/users/$owner/repos', {
        'type': 'public',
        'sort': 'updated',
        'direction': 'desc',
        'per_page': '$safePerPage',
        'page': '$page',
      });
      final response = await _client.get(
        uri,
        headers: const {
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
        },
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw GitHubProjectsException(
          'Unable to load public GitHub repositories.',
          statusCode: response.statusCode,
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! List<dynamic>) {
        throw const GitHubProjectsException(
          'GitHub repository response was not a list.',
        );
      }

      final pageItems = decoded
          .whereType<Map<String, dynamic>>()
          .map(GitHubProjectModel.fromJson)
          .toList(growable: false);
      repositories.addAll(pageItems);

      if (pageItems.length < safePerPage) break;
    }

    return repositories;
  }
}
