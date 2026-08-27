import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../models/portfolio_models.dart';
import 'scroll_reveal.dart';
import 'section_wrapper.dart';

class OpenSourceProjectsSectionWidget extends StatelessWidget {
  const OpenSourceProjectsSectionWidget({
    super.key,
    required this.projects,
    required this.onLinkTap,
  });

  final List<OtherProject> projects;
  final ValueChanged<String> onLinkTap;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();

    return SectionWrapper(
      id: 'open-source-projects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollReveal(
            child: Center(
              child: Column(
                children: [
                  Text(
                    'open_source_projects_title'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'open_source_projects_subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = context.projectGridColumns;
              final width =
                  (constraints.maxWidth - (16.0 * (columns - 1))) / columns;

              return Wrap(
                spacing: 16,
                runSpacing: 20,
                children: projects
                    .map(
                      (project) => SizedBox(
                        width: width,
                        child: _OpenSourceProjectCard(
                          project: project,
                          onLinkTap: onLinkTap,
                        ),
                      ),
                    )
                    .toList(growable: false),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _OpenSourceProjectCard extends StatelessWidget {
  const _OpenSourceProjectCard({
    required this.project,
    required this.onLinkTap,
  });

  final OtherProject project;
  final ValueChanged<String> onLinkTap;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 14,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.code, color: AppTheme.accent),
              const Spacer(),
              if (project.repoUrl.isNotEmpty)
                IconButton(
                  tooltip: 'GitHub',
                  onPressed: () => onLinkTap(project.repoUrl),
                  icon: const Icon(Icons.open_in_new),
                  color: AppTheme.textMuted,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            project.name,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (project.summary.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              project.summary,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textMuted,
                height: 1.5,
              ),
            ),
          ],
          if (project.tags.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: project.tags
                  .map(
                    (tag) => Text(
                      tag,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.accent,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ],
      ),
    );
  }
}
