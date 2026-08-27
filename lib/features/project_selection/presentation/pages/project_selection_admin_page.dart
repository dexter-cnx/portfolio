import 'package:easy_localization/easy_localization.dart';
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('admin_export_copied'.tr())));
  }

  Future<void> _importJson() async {
    final textController = TextEditingController();
    final raw = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('admin_import_title'.tr()),
        content: SizedBox(
          width: 640,
          child: TextField(
            controller: textController,
            minLines: 12,
            maxLines: 20,
            decoration: InputDecoration(
              hintText: 'admin_import_hint'.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('admin_cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(textController.text),
            child: Text('admin_import'.tr()),
          ),
        ],
      ),
    );
    textController.dispose();
    if (raw == null || raw.trim().isEmpty || !mounted) return;

    try {
      _controller.importJson(raw);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('admin_import_success'.tr())));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${'admin_import_invalid'.tr()}: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('admin_title'.tr()),
        actions: [
          TextButton.icon(
            onPressed: _controller.status == ProjectSelectionStatus.ready
                ? _importJson
                : null,
            icon: const Icon(Icons.upload_file_outlined),
            label: Text('admin_import_json'.tr()),
          ),
          TextButton.icon(
            onPressed: _controller.status == ProjectSelectionStatus.ready
                ? _exportJson
                : null,
            icon: const Icon(Icons.content_copy_outlined),
            label: Text('admin_export_json'.tr()),
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
                      'admin_static_notice'.tr(),
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
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              labelText: 'admin_search'.tr(),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        if (_controller.config.updatedAt case final updatedAt?)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${'admin_config_updated'.tr()}: ${updatedAt.toLocal()}',
              ),
            ),
          ),
        const SizedBox(height: 8),
        Expanded(
          child: repositories.isEmpty
              ? Center(child: Text('admin_empty'.tr()))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: repositories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final repo = repositories[index];
                    final config = _controller.config.forRepository(repo.id);
                    return Card(
                      key: ValueKey(repo.id),
                      child: ExpansionTile(
                        title: Text(repo.name),
                        subtitle: Text(
                          repo.description.isEmpty
                              ? repo.fullName
                              : repo.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        childrenPadding: const EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          16,
                        ),
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              FilterChip(
                                label: Text('admin_visible'.tr()),
                                selected: config.visible,
                                onSelected: (value) => _controller
                                    .updateProject(repo.id, visible: value),
                              ),
                              FilterChip(
                                label: Text('admin_featured'.tr()),
                                selected: config.featured,
                                onSelected: (value) =>
                                    _controller.updateProject(
                                      repo.id,
                                      featured: value,
                                      visible: value ? true : null,
                                    ),
                              ),
                              FilterChip(
                                label: Text('admin_include_pdf'.tr()),
                                selected: config.includeInPdf,
                                onSelected: (value) =>
                                    _controller.updateProject(
                                      repo.id,
                                      includeInPdf: value,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: ValueKey(
                              '${repo.id}-sort-${config.sortOrder}',
                            ),
                            initialValue: config.sortOrder.toString(),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'admin_sort_order'.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) => _controller.updateProject(
                              repo.id,
                              sortOrder: int.tryParse(value) ?? 0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: ValueKey(
                              '${repo.id}-title-${config.titleOverride}',
                            ),
                            initialValue: config.titleOverride,
                            decoration: InputDecoration(
                              labelText: 'admin_title_override'.tr(),
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) => _controller.updateProject(
                              repo.id,
                              titleOverride: value,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            key: ValueKey(
                              '${repo.id}-summary-${config.summaryOverride}',
                            ),
                            initialValue: config.summaryOverride,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'admin_summary_override'.tr(),
                              border: const OutlineInputBorder(),
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
            Text(error?.toString() ?? 'admin_load_error'.tr()),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: Text('admin_retry'.tr())),
          ],
        ),
      ),
    );
  }
}
