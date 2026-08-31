import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_theme.dart';
import '../../models/portfolio_models.dart';

class PublicPortfolioShell extends StatelessWidget {
  final Site site;
  final String activeRoute;
  final Widget child;
  final VoidCallback? onPdfTap;

  const PublicPortfolioShell({
    super.key,
    required this.site,
    required this.activeRoute,
    required this.child,
    this.onPdfTap,
  });

  static const _destinations = <(String, String)>[
    ('/', 'Home'),
    ('/projects', 'Projects'),
    ('/open-source', 'Open Source'),
    ('/experience', 'Experience'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background.withValues(alpha: 0.94),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72,
        titleSpacing: 24,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppTheme.outline),
        ),
        title: InkWell(
          onTap: () =>
              Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
          child: Text(
            site.ownerName.isEmpty ? 'PORTFOLIO' : site.ownerName.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        actions: [
          if (MediaQuery.sizeOf(context).width >= 760)
            ..._destinations.map(
              (item) => _NavLink(
                label: item.$2,
                selected: activeRoute == item.$1,
                onTap: () {
                  if (activeRoute != item.$1) {
                    Navigator.of(context).pushNamed(item.$1);
                  }
                },
              ),
            ),
          if (onPdfTap != null)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: FilledButton(
                onPressed: onPdfTap,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                child: const Text('PDF'),
              ),
            ),
          if (MediaQuery.sizeOf(context).width < 760)
            PopupMenuButton<String>(
              tooltip: 'Navigation',
              icon: const Icon(Icons.menu),
              onSelected: (route) {
                if (route != activeRoute) {
                  Navigator.of(context).pushNamed(route);
                }
              },
              itemBuilder: (_) => _destinations
                  .map(
                    (item) => PopupMenuItem<String>(
                      value: item.$1,
                      child: Text(item.$2),
                    ),
                  )
                  .toList(growable: false),
            ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SizedBox.expand(child: child),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavLink({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: selected ? AppTheme.textPrimary : AppTheme.textMuted,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        shape: const RoundedRectangleBorder(),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selected ? AppTheme.textPrimary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class PublicPageContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const PublicPageContainer({
    super.key,
    required this.child,
    this.maxWidth = AppTheme.contentMaxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 768;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: mobile
                    ? AppTheme.mobileGutter
                    : AppTheme.desktopGutter,
                vertical: AppTheme.sectionGap,
              ),
          child: child,
        ),
      ),
    );
  }
}

class PortfolioTagWrap extends StatelessWidget {
  final List<String> tags;

  const PortfolioTagWrap({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppTheme.outline),
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: tag.toLowerCase().contains('rust')
                      ? AppTheme.rustAccent
                      : AppTheme.metaText,
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

Future<void> launchPortfolioUrl(String url) async {
  if (url.trim().isEmpty) return;
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  final mode = uri.scheme == 'http' || uri.scheme == 'https'
      ? LaunchMode.platformDefault
      : LaunchMode.externalApplication;
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: mode);
  }
}
