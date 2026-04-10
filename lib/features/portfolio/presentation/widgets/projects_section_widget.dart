import 'package:easy_localization/easy_localization.dart';
import 'package:cue/cue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/helpers/responsive_helper.dart';
import '../../../../core/widgets/glass_container.dart';
import '../../models/portfolio_models.dart';
import 'portfolio_motion.dart';
import 'section_header.dart';
import 'section_wrapper.dart';
import 'scroll_reveal.dart';
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
          ScrollReveal(
            child: SectionHeader(number: '03', title: 'projects_title'.tr()),
          ),
          const SizedBox(height: 48),

          // ── Featured projects ──────────────────────────────────
          ...featured.asMap().entries.expand((entry) {
            final items = <Widget>[
              _FeaturedProjectCard(
                project: entry.value,
                isReversed: entry.key % 2 != 0,
                revealDelay: staggeredDelay(
                  entry.key,
                  step: kProjectFeaturedCardStagger,
                ),
                onLinkTap: onLinkTap,
              ),
            ];

            if (entry.key != featured.length - 1) {
              items.add(
                SizedBox(
                  height: context.responsive(
                    mobile: 72.0,
                    tablet: 88.0,
                    desktop: 100.0,
                  ),
                ),
              );
            }

            return items;
          }),

          // ── Other projects grid ────────────────────────────────
          if (other.isNotEmpty) ...[
            const SizedBox(height: 100),
            ScrollReveal(
              child: Center(
                child: Text(
                  'projects_others_title'.tr(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
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
    final cols = context.projectGridColumns;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (16.0 * (cols - 1))) / cols;

        return Wrap(
          spacing: 16,
          runSpacing: 20,
          children: other.asMap().entries.map((entry) {
            return SizedBox(
              width: itemWidth,
              child: ScrollReveal(
                delay: staggeredDelay(
                  entry.key,
                  step: kProjectOtherCardStagger,
                ),
                child: _OtherProjectCard(
                  project: entry.value,
                  onLinkTap: onLinkTap,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ── Featured Project Card ─────────────────────────────────────────────────────

class _FeaturedProjectCard extends StatefulWidget {
  final FeaturedProject project;
  final bool isReversed;
  final Duration revealDelay;
  final Function(String url) onLinkTap;

  const _FeaturedProjectCard({
    required this.project,
    required this.onLinkTap,
    required this.revealDelay,
    this.isReversed = false,
  });

  @override
  State<_FeaturedProjectCard> createState() => _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends State<_FeaturedProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Cue.onScrollVisible(
      child: ResponsiveLayout.isDesktop(context)
          ? _buildDesktop(context)
          : _buildMobile(context),
    );
  }

  // ── Mobile layout: full-width card with image on top ──────────────────────

  Widget _buildMobile(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.01 : 1.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Actor(
          delay: widget.revealDelay,
          acts: const [
            Act.fadeIn(),
            Act.slideY(from: kCardRevealSlideFrom),
          ],
          child: GlassContainer(
            blur: _hovered ? 16 : 10,
            backgroundOpacity: _hovered ? 0.09 : 0.05,
            borderOpacity: _hovered ? 0.25 : 0.12,
            borderRadius: 16,
            margin: const EdgeInsets.only(bottom: 48),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.accent.withValues(alpha: 0.12),
                      blurRadius: 40,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Actor(
                  delay: kProjectImageDelay,
                  acts: const [Act.fadeIn(), Act.scale(from: 0.92)],
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: _ProjectImageGallery(
                        images: widget.project.images,
                        isHovered: _hovered,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildContent(
                    context,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Desktop layout: overlapping image + glass content card ────────────────

  Widget _buildDesktop(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: SizedBox(
        height: 520,
        child: Stack(
          children: [
            // Project image (60 % width, left or right)
            Positioned(
              left: widget.isReversed ? null : 0,
              right: widget.isReversed ? 0 : null,
              top: 0,
              bottom: 0,
              width: 620,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Actor(
                  delay: widget.revealDelay + kProjectImageDelay,
                  acts: const [Act.fadeIn(), Act.scale(from: 0.92)],
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: AppTheme.accent.withValues(alpha: 0.08),
                                blurRadius: 40,
                              ),
                            ]
                          : [],
                    ),
                    child: _ProjectImageGallery(
                      images: widget.project.images,
                      isHovered: _hovered,
                    ),
                  ),
                ),
              ),
            ),

            // Glass content overlay card (opposite side)
            Positioned(
              left: widget.isReversed ? 0 : null,
              right: widget.isReversed ? null : 0,
              top: 40,
              bottom: 40,
              width: 480,
              child: GlassContainer.heavy(
                blur: _hovered ? 24 : 16,
                backgroundOpacity: _hovered ? 0.11 : 0.07,
                borderOpacity: _hovered ? 0.28 : 0.16,
                borderRadius: 16,
                padding: const EdgeInsets.all(28),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppTheme.accent.withValues(alpha: 0.14),
                          blurRadius: 50,
                          spreadRadius: -4,
                          offset: const Offset(0, 16),
                        ),
                      ]
                    : null,
                child: _buildContent(
                  context,
                  crossAxisAlignment: widget.isReversed
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required CrossAxisAlignment crossAxisAlignment,
  }) {
    final isRight = crossAxisAlignment == CrossAxisAlignment.end;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Actor(
            delay: kProjectContentLeadDelay,
            acts: const [
              Act.fadeIn(),
              Act.slideY(from: kSectionHeaderSlideFrom),
            ],
            child: Text(
              'project_type'.tr(),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.accent,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ),
          const SizedBox(height: 8),

          Actor(
            delay: kProjectContentLeadDelay + kProjectContentStep,
            acts: const [
              Act.fadeIn(),
              Act.slideY(from: kSectionHeaderSlideFrom),
            ],
            child: Text(
              widget.project.name,
              textAlign: isRight ? TextAlign.right : TextAlign.left,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: _hovered ? AppTheme.accent : AppTheme.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Actor(
            delay: kProjectContentLeadDelay + (kProjectContentStep * 2),
            acts: const [
              Act.fadeIn(),
              Act.slideY(from: kSectionHeaderSlideFrom),
            ],
            child: Text(
              widget.project.summary,
              textAlign: isRight ? TextAlign.right : TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.textPrimary,
                height: 1.6,
              ),
            ),
          ),

          if (widget.project.longDescription.isNotEmpty) ...[
            const SizedBox(height: 10),
            Actor(
              delay: kProjectContentLeadDelay + (kProjectContentStep * 3),
              acts: const [
                Act.fadeIn(),
                Act.slideY(from: kSectionHeaderSlideFrom),
              ],
              child: Text(
                widget.project.longDescription,
                textAlign: isRight ? TextAlign.right : TextAlign.left,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Store / live links
          if (widget.project.urls.isNotEmpty) ...[
            Actor(
              delay: kProjectContentLeadDelay + (kProjectContentStep * 4),
              acts: const [
                Act.fadeIn(),
                Act.slideY(from: kContentRevealSlideFrom),
              ],
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: isRight ? WrapAlignment.end : WrapAlignment.start,
                children: widget.project.urls
                    .map(
                      (u) =>
                          _ProjectUrlItem(url: u, onLaunch: widget.onLinkTap),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Tech tags
          Actor(
            delay: kProjectContentLeadDelay + (kProjectContentStep * 5),
            acts: const [
              Act.fadeIn(),
              Act.slideY(from: kContentRevealSlideFrom),
            ],
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: isRight ? WrapAlignment.end : WrapAlignment.start,
              children: widget.project.tags
                  .map(
                    (t) => Text(
                      t,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.textMuted,
                        fontFamily: 'JetBrains Mono',
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Icon links (GitHub / Live)
          Actor(
            delay: kProjectContentLeadDelay + (kProjectContentStep * 6),
            acts: const [
              Act.fadeIn(),
              Act.slideY(from: kContentRevealSlideFrom),
            ],
            child: Row(
              mainAxisAlignment: isRight
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                if (widget.project.repoUrl.isNotEmpty)
                  _IconLink(
                    icon: Icons.code,
                    tooltip: 'Source',
                    onTap: () => widget.onLinkTap(widget.project.repoUrl),
                  ),
                if (widget.project.liveUrl.isNotEmpty)
                  _IconLink(
                    icon: Icons.open_in_new,
                    tooltip: 'Live',
                    onTap: () => widget.onLinkTap(widget.project.liveUrl),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Other Project Card ────────────────────────────────────────────────────────

class _OtherProjectCard extends StatefulWidget {
  final OtherProject project;
  final Function(String url) onLinkTap;

  const _OtherProjectCard({required this.project, required this.onLinkTap});

  @override
  State<_OtherProjectCard> createState() => _OtherProjectCardState();
}

class _OtherProjectCardState extends State<_OtherProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        child: ResponsiveLayout.isDesktop(context)
            ? SizedBox(height: 340, child: _buildCard(context, compact: true))
            : _buildCard(context, compact: false),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required bool compact}) {
    return GlassContainer(
      blur: _hovered ? 18 : 10,
      backgroundOpacity: _hovered ? 0.10 : 0.05,
      borderOpacity: _hovered ? 0.28 : 0.13,
      borderRadius: 14,
      boxShadow: _hovered
          ? [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.16),
                blurRadius: 32,
                spreadRadius: -2,
                offset: const Offset(0, 8),
              ),
            ]
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (widget.project.images.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(13),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _ProjectImageGallery(
                  images: widget.project.images,
                  isHovered: _hovered,
                ),
              ),
            ),

          // Content
          Padding(
            padding: EdgeInsets.all(compact ? 18 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.project.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: _hovered
                                  ? AppTheme.accent
                                  : AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.project.repoUrl.isNotEmpty)
                          _IconLink(
                            icon: Icons.code,
                            tooltip: 'Source',
                            size: 18,
                            onTap: () =>
                                widget.onLinkTap(widget.project.repoUrl),
                          ),
                        if (widget.project.liveUrl.isNotEmpty)
                          _IconLink(
                            icon: Icons.open_in_new,
                            tooltip: 'Live',
                            size: 18,
                            onTap: () =>
                                widget.onLinkTap(widget.project.liveUrl),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.project.summary,
                  maxLines: compact ? 2 : null,
                  overflow: compact
                      ? TextOverflow.ellipsis
                      : TextOverflow.visible,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMuted,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: widget.project.tags
                      .map(
                        (t) => Text(
                          t,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppTheme.textMuted,
                                fontFamily: 'JetBrains Mono',
                                fontSize: 10,
                              ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ────────────────────────────────────────────────────────

class _IconLink extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final double size;

  const _IconLink({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.size = 20,
  });

  @override
  State<_IconLink> createState() => _IconLinkState();
}

class _IconLinkState extends State<_IconLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: Icon(
                widget.icon,
                key: ValueKey(_hovered),
                size: widget.size,
                color: _hovered ? AppTheme.accent : AppTheme.textMuted,
              ),
            ),
          ),
        ),
      ),
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
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.35)),
          borderRadius: BorderRadius.circular(6),
          color: AppTheme.accent.withValues(alpha: 0.06),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (url.image.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: url.image.endsWith('.svg')
                    ? SvgPicture.asset(url.image, width: 18, height: 18)
                    : Image.asset(
                        url.image,
                        width: 18,
                        height: 18,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 6),
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

// ── Image gallery with page indicators ───────────────────────────────────────

class _ProjectImageGallery extends StatefulWidget {
  final List<String> images;
  final bool isHovered;

  const _ProjectImageGallery({required this.images, this.isHovered = false});

  @override
  State<_ProjectImageGallery> createState() => _ProjectImageGalleryState();
}

class _ProjectImageGalleryState extends State<_ProjectImageGallery> {
  late final PageController _pageCtrl;
  int _page = 0;

  static const int _kLoopFactor = 1000;

  int get _currentIndex =>
      widget.images.isEmpty ? 0 : _page % widget.images.length;

  int get _initialPage =>
      widget.images.length <= 1 ? 0 : widget.images.length * _kLoopFactor;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: _initialPage);
    _page = _initialPage;
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return Container(color: AppTheme.surfaceContainer);
    }

    return Stack(
      children: [
        // Swipeable page view
        PageView.builder(
          controller: _pageCtrl,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => Container(
            color: AppTheme.surfaceLow,
            padding: const EdgeInsets.all(6),
            child: Image.asset(
              widget.images[i % widget.images.length],
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),

        // Subtle tint overlay (clears on hover)
        IgnorePointer(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: widget.isHovered
                ? Colors.transparent
                : AppTheme.accent.withValues(alpha: 0.20),
          ),
        ),

        // Page indicators
        if (widget.images.length > 1) ...[
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.asMap().entries.map((e) {
                final active = _currentIndex == e.key;
                return GestureDetector(
                  onTap: () => _animateToImageIndex(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: active ? 20 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: active
                          ? AppTheme.accent
                          : Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Arrow buttons
          Positioned(
            left: 4,
            top: 0,
            bottom: 0,
            child: Center(
              child: _Arrow(icon: Icons.chevron_left, onTap: _goToPreviousPage),
            ),
          ),
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: Center(
              child: _Arrow(icon: Icons.chevron_right, onTap: _goToNextPage),
            ),
          ),
        ],
      ],
    );
  }

  void _goToPreviousPage() {
    if (!mounted || !_pageCtrl.hasClients) return;

    _pageCtrl.animateToPage(
      _page - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToNextPage() {
    if (!mounted || !_pageCtrl.hasClients) return;

    _pageCtrl.animateToPage(
      _page + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _animateToImageIndex(int imageIndex) {
    if (!mounted || !_pageCtrl.hasClients) return;

    final targetPage = _page - _currentIndex + imageIndex;
    _pageCtrl.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class _Arrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _Arrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
