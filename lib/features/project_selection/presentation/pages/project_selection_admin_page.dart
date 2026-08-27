import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../github_projects/data/datasources/github_project_remote_data_source.dart';
import '../../../github_projects/data/repositories/github_project_repository_impl.dart';
import '../../../github_projects/github_projects_config.dart';
import '../../data/repositories/asset_project_selection_store.dart';
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
      store: const AssetProjectSelectionStore(),
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

  Future<void> _exportJson() async {
    final json = _controller.exportJson();
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Project selection JSON copied. Replace assets/content/project_selection.json and commit it.',
        ),
      ),
    );
  }

  Future<void> _importJson() async {
    final textController = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import project selection JSON'),
        content: SizedBox(
          width: 640,
          child: TextField(
            controller: textController,
            minLines: 12,
            maxLines: 20,
            decoration: const InputDecoration(
              hintText: 'Paste project_selection.json here',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(textController.text),
            child: const Text('Import'),
          ),
        ],
      ),
    );
    textController.dispose();
    if (raw == null || raw.trim().isEmpty || !mounted) return;

    try {
      _controller.importJson(raw);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('JSON imported into the editor.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid project selection JSON: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio project admin'),
        actions: [
          TextButton.icon(
            onPressed: _controller.status == ProjectSelectionStatus.ready
                ? _importJson
                : null,
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Import JSON'),
          ),
          TextButton.icon(
            onPressed: _controller.status == ProjectSelectionStatus.ready
                ? _exportJson
                : null,
            icon: const Icon(Icons.content_copy_outlined),
            label: const Text('Export JSON'),
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
        ProjectSelectionStatus.ready => _buildContent(context),
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    final repositories = _controller.filteredRepositories;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This static site cannot write bundled assets. Edit selections here, export JSON, replace assets/content/project_selection.json in the repository, then commit and deploy.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
              child: Text('Config updated: ${updatedAt.toLocal()}'),
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
                            key: ValueKey('${repo.id}-sort-${config.sortOrder}'),
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
                            key: ValueKey('${repo.id}-title-${config.titleOverride}'),
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
                            key: ValueKey('${repo.id}-summary-${config.summaryOverride}'),
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
