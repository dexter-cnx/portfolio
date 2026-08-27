import '../entities/portfolio_project_config.dart';

abstract interface class ProjectSelectionStore {
  Future<ProjectSelectionConfig> load();
  Future<void> save(ProjectSelectionConfig config);
}
