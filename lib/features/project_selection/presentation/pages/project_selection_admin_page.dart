import 'package:flutter/material.dart';

import '../../../github_projects/data/datasources/github_project_remote_data_source.dart';
import '../../../github_projects/data/repositories/github_project_repository_impl.dart';
import '../../../github_projects/github_projects_config.dart';
import '../../data/repositories/in_memory_project_selection_store.dart';
import '../project_selection_controller.dart';

class ProjectSelectionAdminPage extends StatefulWidget {
  const ProjectSelectionAdminPage({super.key});

  @override
  State<ProjectSelectionAdminPage> createState() =>
      _ProjectSelectionAdminPageState();
}

class _ProjectSelectionAdminPageState extends State<ProjectSelectionAdminPage> {
  late final ProjectSelectionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProjectSelectionController(
      githubRepository: GitHubProjectRepositoryImpl(
        owner: portfolioGitHubOwner,
        remoteDataSource: GitHubProjectRemoteDataSourceImpl(),
      ),
      store: InMemoryProjectSelectionStore(),
    )..addListener(_onChanged);
    _controller.load();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio project admin'),
        actions: [
          TextButton.icon(
            onPressed: _controller.status == ProjectSelectionStatus.saving
                ? null
                : _controller.save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
      body: switch (_controller.status) {
        ProjectSelectionStatus.initial || ProjectSelectionStatus.loading =>
          const Center(child: CircularProgressIndicator()),
        ProjectSelectionStatus.error => _ErrorState(
            error: _controller.error,
            onRetry: _controller.load,
          ),
        _ => _buildContent(context),
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final repositories = _controller.filteredRepositories;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            onChanged: _controller.setSearch,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search repositories',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        if (_controller.config.updatedAt case final updatedAt?)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Last saved: ${updatedAt.toLocal()}'),
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: repositories.isEmpty
              ? const Center(child: Text('No repositories found'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: repositories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final repo = repositories[index];
                    final config = _controller.config.forRepository(repo.id);
                    return Card(
                      child: ExpansionTile(
                        title: Text(repo.name),
                        subtitle: Text(
                          repo.description.isEmpty
                              ? repo.fullName
                              : repo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              FilterChip(
                                label: const Text('Visible'),
                                selected: config.visible,
                                onSelected: (value) => _controller.updateProject(
                                  repo.id,
                                  visible: value,
                                ),
                              ),
                              FilterChip(
                                label: const Text('Featured'),
                                selected: config.featured,
                                onSelected: (value) => _controller.updateProject(
                                  repo.id,
                                  featured: value,
                                  visible: value ? true : null,
                                ),
                              ),
                              FilterChip(
                                label: const Text('Include in PDF'),
                                selected: config.includeInPdf,
                                onSelected: (value) => _controller.updateProject(
                                  repo.id,
                                  includeInPdf: value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: config.sortOrder.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Sort order',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _controller.updateProject(
                              repo.id,
                              sortOrder: int.tryParse(value) ?? 0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: config.titleOverride,
                            decoration: const InputDecoration(
                              labelText: 'Title override',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _controller.updateProject(
                              repo.id,
                              titleOverride: value,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: config.summaryOverride,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Summary override',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _controller.updateProject(
                              repo.id,
                              summaryOverride: value,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.error, required this.onRetry});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(error?.toString() ?? 'Unable to load repositories'),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
