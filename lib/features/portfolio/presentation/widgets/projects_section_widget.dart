import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';
import 'section_header.dart';
import 'section_wrapper.dart';
import 'responsive_layout.dart';

class ProjectsSectionWidget extends StatelessWidget {
  final List<FeaturedProject> featured;
  final List<OtherProject> other;
  final Function(String url) onLinkTap;

  const ProjectsSectionWidget({
    super.key,
    required this.featured,
    required this.other,
    required this.onLinkTap,
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
                onLinkTap: onLinkTap,
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
          childAspectRatio: 0.75,
        ),
        itemCount: other.length,
        itemBuilder: (context, index) => _OtherProjectCard(
          project: other[index],
          onLinkTap: onLinkTap,
        ),
      );
    });
  }
}

class _FeaturedProjectCard extends StatelessWidget {
  final FeaturedProject project;
  final bool isReversed;
  final Function(String url) onLinkTap;

  const _FeaturedProjectCard({
    required this.project, 
    required this.onLinkTap,
    this.isReversed = false,
  });

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
              child: _ProjectImageGallery(images: project.images),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flutter Project',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppTheme.accent),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    project.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.textPrimary),
                  ),
                  const SizedBox(height: 16),
                  Text(project.summary, style: Theme.of(context).textTheme.bodyLarge),
                  if (project.longDescription.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(project.longDescription, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 16),
                  _buildProjectUrls(context),
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
      height: 600, // Increased height to accommodate urls and long descriptions
      margin: const EdgeInsets.only(bottom: 100),
      child: Stack(
        children: [
          // Project Image Gallery
          Positioned(
            left: isReversed ? null : 0,
            right: isReversed ? 0 : null,
            top: 0,
            bottom: 0,
            width: 700,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _ProjectImageGallery(images: project.images),
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
                  'Flutter Project',
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
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isReversed ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                    children: [
                      Text(
                        project.summary,
                        textAlign: isReversed ? TextAlign.left : TextAlign.right,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textPrimary,
                            ),
                      ),
                      if (project.longDescription.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          project.longDescription,
                          textAlign: isReversed ? TextAlign.left : TextAlign.right,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textMuted,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildProjectUrls(context),
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
                        onPressed: () => onLinkTap(project.repoUrl),
                        icon: const Icon(Icons.code, color: AppTheme.textPrimary),
                      ),
                    if (project.liveUrl.isNotEmpty)
                      IconButton(
                        onPressed: () => onLinkTap(project.liveUrl),
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

  Widget _buildProjectUrls(BuildContext context) {
    if (project.urls.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: isReversed ? WrapAlignment.start : WrapAlignment.end,
      children: project.urls.map((u) => _ProjectUrlItem(url: u, onLaunch: onLinkTap)).toList(),
    );
  }
}

class _ProjectUrlItem extends StatelessWidget {
  final ProjectUrl url;
  final Function(String url) onLaunch;

  const _ProjectUrlItem({required this.url, required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onLaunch(url.url),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(4),
          color: AppTheme.accent.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (url.image.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: url.image.endsWith('.svg')
                    ? SvgPicture.asset(url.image, width: 20, height: 20)
                    : Image.asset(url.image, width: 20, height: 20, fit: BoxFit.cover),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              url.title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppTheme.accent,
                    fontFamily: 'JetBrains Mono',
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OtherProjectCard extends StatefulWidget {
  final OtherProject project;
  final Function(String url) onLinkTap;

  const _OtherProjectCard({required this.project, required this.onLinkTap});

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
        transform: Matrix4.translationValues(0.0, _isHovered ? -8.0 : 0.0, 0.0),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            if (_isHovered)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image gallery at top
            if (widget.project.images.isNotEmpty)
              AspectRatio(
                aspectRatio: 16 / 10,
                child: _ProjectImageGallery(images: widget.project.images),
              ),

            // Content below
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.project.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: _isHovered ? AppTheme.accent : AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.project.repoUrl.isNotEmpty)
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => widget.onLinkTap(widget.project.repoUrl),
                                icon: const Icon(Icons.code, color: AppTheme.textMuted, size: 18),
                              ),
                            if (widget.project.liveUrl.isNotEmpty) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () => widget.onLinkTap(widget.project.liveUrl),
                                icon: const Icon(Icons.open_in_new, color: AppTheme.textMuted, size: 18),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.project.summary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textMuted,
                          ),
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: widget.project.tags
                          .map((t) => Text(
                                t,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: AppTheme.textMuted,
                                      fontFamily: 'JetBrains Mono',
                                      fontSize: 10,
                                    ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectImageGallery extends StatefulWidget {
  final List<String> images;

  const _ProjectImageGallery({required this.images});

  @override
  State<_ProjectImageGallery> createState() => _ProjectImageGalleryState();
}

class _ProjectImageGalleryState extends State<_ProjectImageGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(color: AppTheme.surfaceContainer);
    }

    return Container(
      color: AppTheme.surfaceLow,
      child: Stack(
        children: [
          // Swipeable PageView
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return Container(
                color: AppTheme.surfaceLow,
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  widget.images[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),

          // Subtle tint overlay — IgnorePointer so swipe still works
          IgnorePointer(
            child: Container(color: AppTheme.accent.withValues(alpha: 0.08)),
          ),

          // Page indicators
          if (widget.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.images.asMap().entries.map((entry) {
                  final isActive = _currentPage == entry.key;
                  return GestureDetector(
                    onTap: () => _pageController.animateToPage(
                      entry.key,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isActive ? 24 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: isActive
                            ? AppTheme.accent
                            : Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Left arrow — positioned at left edge only
          if (widget.images.length > 1)
            Positioned(
              left: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_left,
                  onTap: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),

          // Right arrow — positioned at right edge only
          if (widget.images.length > 1)
            Positioned(
              right: 4,
              top: 0,
              bottom: 0,
              child: Center(
                child: _ArrowButton(
                  icon: Icons.chevron_right,
                  onTap: () => _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Compact, translucent arrow button that doesn't block swipe area.
class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
