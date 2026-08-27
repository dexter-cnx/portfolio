import '../../domain/entities/portfolio_project_config.dart';
import '../../domain/repositories/project_selection_store.dart';

final class InMemoryProjectSelectionStore implements ProjectSelectionStore {
  ProjectSelectionConfig _config = const ProjectSelectionConfig();

  @override
  Future<ProjectSelectionConfig> load() async => _config;

  @override
  Future<void> save(ProjectSelectionConfig config) async {
    _config = ProjectSelectionConfig(
      projects: List<PortfolioProjectConfig>.unmodifiable(config.projects),
      updatedAt: DateTime.now().toUtc(),
    );
  }
}
