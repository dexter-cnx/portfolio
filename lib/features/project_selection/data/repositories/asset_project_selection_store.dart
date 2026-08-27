import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/entities/portfolio_project_config.dart';
import '../../domain/repositories/project_selection_store.dart';

final class AssetProjectSelectionStore implements ProjectSelectionStore {
  const AssetProjectSelectionStore({
    this.assetPath = 'assets/content/project_selection.json',
  });

  final String assetPath;

  @override
  Future<ProjectSelectionConfig> load() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Project selection config must be a JSON object.',
      );
    }
    return ProjectSelectionConfig.fromJson(decoded);
  }

  @override
  Future<void> save(ProjectSelectionConfig config) {
    throw UnsupportedError(
      'Bundled Flutter assets are read-only. Export JSON and commit the file instead.',
    );
  }
}
