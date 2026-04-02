import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_header.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

class ProjectsSectionWidget extends StatelessWidget {
  final List<FeaturedProject> featured;
  final List<OtherProject> other;

  const ProjectsSectionWidget({
    super.key,
    required this.featured,
    required this.other,
  });

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      id: 'projects',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(number: '03', title: "Some Things I've Built"),
          const SizedBox(height: 40),
          ...featured.asMap().entries.map((entry) => _FeaturedProjectCard(
                project: entry.value,
                isReversed: entry.key % 2 != 0,
              )),
          if (other.isNotEmpty) ...[
            const SizedBox(height: 100),
            Center(
              child: Text(
                'Other Noteworthy Projects',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 40),
            _buildOthersGrid(context),
          ],
        ],
      ),
    );
  }

  Widget _buildOthersGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final crossAxisCount = constraints.maxWidth > 1000
          ? 3
          : constraints.maxWidth > 600
              ? 2
              : 1;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 1.2,
        ),
        itemCount: other.length,
        itemBuilder: (context, index) => _OtherProjectCard(project: other[index]),
      );
    });
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final FeaturedProject project;
  final bool isReversed;

  const _FeaturedProjectCard({required this.project, this.isReversed = false});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveLayout.isDesktop(context);

    if (!isDesktop) {
      return Container(
        margin: const EdgeInsets.only(bottom: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppTheme.surfaceContainer,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(project.image, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Project',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.accent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(project.summary, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: project.tags
                        .map((t) => Text(t, style: Theme.of(context).textTheme.labelSmall))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: 400,
      margin: const EdgeInsets.only(bottom: 100),
      child: Stack(
        children: [
          // Project Image
          Positioned(
            left: isReversed ? null : 0,
            right: isReversed ? 0 : null,
            top: 0,
            bottom: 0,
            width: 600,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                children: [
                  Image.asset(project.image, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                  Container(color: AppTheme.accent.withOpacity(0.2)),
                ],
              ),
            ),
          ),
          // Project Content
          Positioned(
            left: isReversed ? 0 : null,
            right: isReversed ? null : 0,
            top: 20,
            bottom: 20,
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: isReversed ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Text(
                  'Featured Project',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppTheme.accent,
                        fontFamily: 'JetBrains Mono',
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  project.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    project.summary,
                    textAlign: isReversed ? TextAlign.left : TextAlign.right,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: isReversed ? WrapAlignment.start : WrapAlignment.end,
                  children: project.tags
                      .map((t) => Text(
                            t,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppTheme.textMuted,
                                  fontFamily: 'JetBrains Mono',
                                ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: isReversed ? MainAxisAlignment.start : MainAxisAlignment.end,
                  children: [
                    if (project.repoUrl.isNotEmpty)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.code, color: AppTheme.textPrimary),
                      ),
                    if (project.liveUrl.isNotEmpty)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.open_in_new, color: AppTheme.textPrimary),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OtherProjectCard extends StatefulWidget {
  final OtherProject project;

  const _OtherProjectCard({required this.project});

  @override
  State<_OtherProjectCard> createState() => _OtherProjectCardState();
}

class _OtherProjectCardState extends State<_OtherProjectCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        transform: Matrix4.identity()..translate(0.0, _isHovered ? -8.0 : 0.0),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.folder_outlined, color: AppTheme.accent, size: 40),
                Row(
                  children: [
                    if (widget.project.repoUrl.isNotEmpty)
                      const Icon(Icons.code, color: AppTheme.textMuted, size: 20),
                    if (widget.project.liveUrl.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Icon(Icons.open_in_new, color: AppTheme.textMuted, size: 20),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              widget.project.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: _isHovered ? AppTheme.accent : AppTheme.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.project.summary,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: widget.project.tags
                  .map((t) => Text(
                        t,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppTheme.textMuted,
                              fontFamily: 'JetBrains Mono',
                            ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
