import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../github_projects/data/datasources/github_project_remote_data_source.dart';
import '../../../github_projects/data/repositories/github_project_repository_impl.dart';
import '../../../github_projects/github_projects_config.dart';
import '../../../project_selection/data/repositories/asset_project_selection_store.dart';
import '../../../repository_status/application/portfolio_projects_loader.dart';
import '../../../repository_status/data/datasources/repository_portfolio_status_remote_data_source.dart';
import '../../models/portfolio_models.dart';

class LocalContentLoader {
  LocalContentLoader({PortfolioProjectsLoader? projectsLoader})
      : _projectsLoader = projectsLoader ??
            PortfolioProjectsLoader(
              githubRepository: GitHubProjectRepositoryImpl(
                owner: portfolioGitHubOwner,
                remoteDataSource: GitHubProjectRemoteDataSourceImpl(),
              ),
              selectionStore: const AssetProjectSelectionStore(),
              statusDataSource: RepositoryPortfolioStatusRemoteDataSourceImpl(),
            );

  final PortfolioProjectsLoader _projectsLoader;

  Future<PortfolioData> loadPortfolioData([String locale = 'en']) async {
    final path = 'assets/content/portfolio_content_$locale.json';
    final response = await rootBundle.loadString(path);
    final decoded = jsonDecode(response);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Portfolio content must be a JSON object.');
    }
    final fallback = PortfolioData.fromJson(decoded);
    return _projectsLoader.enrich(fallback, languageCode: locale);
  }

  Future<String> loadRawJson([String locale = 'en']) {
    return rootBundle.loadString('assets/content/portfolio_content_$locale.json');
  }
}
