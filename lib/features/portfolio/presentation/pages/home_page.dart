import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../portfolio_documents/domain/reporting/portfolio_report_template.dart';
import '../../data/datasources/local_content_loader.dart';
import '../../models/portfolio_data_with_export_selection.dart';
import '../../models/portfolio_models.dart';
import '../widgets/public_portfolio_shell.dart';
import '../widgets/resume_pdf_generator.dart';
import 'project_detail_page.dart';

class PortfolioHomePage extends StatefulWidget {
  final Function(String) onLocaleChanged;

  const PortfolioHomePage({super.key, required this.onLocaleChanged});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _loader = const LocalContentLoader();
  late Future<PortfolioData> _future;
  String? _locale;

  @override
  void initState() {
    super.initState();
    _future = Future.value(PortfolioData.empty());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale.languageCode;
    if (_locale != locale) {
      _locale = locale;
      _future = _loader.loadPortfolioData(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioData>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.site.ownerName.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final data = snapshot.data!;
        final openSource = data is PortfolioDataWithExportSelection
            ? data.openSourceProjects
            : const <OtherProject>[];

        return PublicPortfolioShell(
          site: data.site,
          activeRoute: '/',
          onPdfTap: () =>
              _generatePdf(data, PortfolioReportTemplateId.portfolioFull),
          child: SingleChildScrollView(
            child: PublicPageContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Hero(data: data, onLocaleChanged: widget.onLocaleChanged),
                  const SizedBox(height: 72),
                  _FeaturedWork(
                    projects: data.featuredProjects
                        .take(3)
                        .toList(growable: false),
                  ),
                  const SizedBox(height: 72),
                  const _CatalogBridge(),
                  const SizedBox(height: 72),
                  _OpenSourcePreview(
                    projects: openSource.take(5).toList(growable: false),
                  ),
                  const SizedBox(height: 72),
                  _EngineeringApproach(skills: data.about.skills),
                  const SizedBox(height: 72),
                  _SelectedExperience(
                    experience: data.experience.take(3).toList(growable: false),
                  ),
                  const SizedBox(height: 72),
                  _PdfCallout(
                    onResume: () => _generatePdf(
                      data,
                      PortfolioReportTemplateId.resumeCompact,
                    ),
                    onPortfolio: () => _generatePdf(
                      data,
                      PortfolioReportTemplateId.portfolioFull,
                    ),
                  ),
                  const SizedBox(height: 72),
                  _ContactFooter(data: data),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _generatePdf(PortfolioData data, PortfolioReportTemplateId template) {
    ResumePdfGenerator.generateAndDownload(
      data,
      context.locale.languageCode,
      template: template,
    );
  }
}

class _Hero extends StatelessWidget {
  final PortfolioData data;
  final Function(String) onLocaleChanged;

  const _Hero({required this.data, required this.onLocaleChanged});

  @override
  Widget build(BuildContext context) {
    final hero = data.hero;
    final thai = context.locale.languageCode == 'th';
    final wide = MediaQuery.sizeOf(context).width >= 860;
    final profileImage = data.about.profileImage;

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                border: Border.all(color: AppTheme.outline),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.site.location,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => onLocaleChanged(thai ? 'en' : 'th'),
              child: Text(thai ? 'EN' : 'TH'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          data.site.ownerName,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.metaText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.site.role.isEmpty ? hero.subheadline : data.site.role,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: 10),
        Text(
          hero.subheadline,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppTheme.metaText,
          ),
        ),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Text(
            hero.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Text(
              '20+ Years Software',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'Mobile Engineering',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'Flutter / Dart',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Text(
              'Open Source',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/projects'),
              child: const Text('View Projects'),
            ),
            OutlinedButton(
              onPressed: () => launchPortfolioUrl(data.site.resumeUrl),
              child: const Text('Resume'),
            ),
            TextButton(
              onPressed: () {
                final github = data.socialLinks
                    .where(
                      (item) =>
                          item.label.toLowerCase().contains('github'),
                    )
                    .firstOrNull;
                if (github != null) launchPortfolioUrl(github.url);
              },
              child: const Text('GitHub ↗'),
            ),
          ],
        ),
      ],
    );

    final profile = Container(
      width: wide ? 280 : double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        border: Border.all(color: AppTheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profileImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.asset(
                  profileImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppTheme.surfaceLow,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.person_outline,
                      size: 72,
                      color: AppTheme.metaText,
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          Text(
            'CONTACT',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 10),
          Text(data.site.email, style: Theme.of(context).textTheme.bodySmall),
          if ((data.contact.phone ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'Tel: ${data.contact.phone}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if ((data.contact.lineId ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'LINE: ${data.contact.lineId}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );

    return wide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: textContent),
              const SizedBox(width: 48),
              profile,
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [textContent, const SizedBox(height: 32), profile],
          );
  }
}

class _FeaturedWork extends StatelessWidget {
  final List<FeaturedProject> projects;

  const _FeaturedWork({required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeSectionHeader(
          title: 'Featured Work',
          actionLabel: 'Explore All Projects →',
          onAction: () => Navigator.of(context).pushNamed('/projects'),
        ),
        const SizedBox(height: 24),
        ...projects.map(
          (project) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                border: Border.all(color: AppTheme.outline),
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          project.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      PortfolioTagWrap(
                        tags: project.tags.take(3).toList(growable: false),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    project.summary,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (project.longDescription.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      project.longDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                ProjectDetailPage(project: project),
                          ),
                        ),
                        child: const Text('View Case Study'),
                      ),
                      if (project.repoUrl.isNotEmpty)
                        TextButton(
                          onPressed: () => launchPortfolioUrl(project.repoUrl),
                          child: const Text('GitHub →'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CatalogBridge extends StatelessWidget {
  const _CatalogBridge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow.withValues(alpha: 0.92),
        border: Border.all(color: AppTheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Column(
        children: [
          Text(
            'Complete Portfolio Catalog',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'Browse the full archive across applications, packages, tools, and technologies.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Text(
            'Flutter Apps  ·  Packages  ·  Developer Tools  ·  Open Source',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () => Navigator.of(context).pushNamed('/projects'),
            child: const Text('Explore All Projects'),
          ),
        ],
      ),
    );
  }
}

class _OpenSourcePreview extends StatelessWidget {
  final List<OtherProject> projects;

  const _OpenSourcePreview({required this.projects});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeSectionHeader(
          title: 'Open Source',
          actionLabel: 'View All →',
          onAction: () => Navigator.of(context).pushNamed('/open-source'),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 820
                ? 3
                : constraints.maxWidth >= 540
                ? 2
                : 1;
            const gap = 14.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: projects
                  .map(
                    (project) => SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          border: Border.all(color: AppTheme.outline),
                          borderRadius: BorderRadius.circular(
                            AppTheme.cardRadius,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              project.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              project.summary,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 14),
                            PortfolioTagWrap(
                              tags: project.tags
                                  .take(2)
                                  .toList(growable: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

class _EngineeringApproach extends StatelessWidget {
  final List<String> skills;

  const _EngineeringApproach({required this.skills});

  @override
  Widget build(BuildContext context) {
    final skillLine = skills.take(8).join(' · ');
    const items = <(String, String)>[
      (
        'Mobile-first architecture',
        'Build product flows around practical mobile constraints, platform behavior, and maintainable boundaries.',
      ),
      (
        'Native integration when useful',
        'Keep Flutter productive while using platform or systems code where performance and capability justify it.',
      ),
      (
        'Local and predictable state',
        'Favor explicit state and data ownership so user-facing behavior stays understandable and testable.',
      ),
      (
        'Production delivery',
        'Treat CI, testing, store delivery, reliability, and maintainability as part of implementation rather than afterthoughts.',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _HomeSectionHeader(title: 'Engineering Approach'),
        const SizedBox(height: 10),
        if (skillLine.isNotEmpty)
          Text(skillLine, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 700 ? 2 : 1;
            const gap = 14.0;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: items
                  .map(
                    (item) => SizedBox(
                      width: width,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          border: Border.all(color: AppTheme.outline),
                          borderRadius: BorderRadius.circular(
                            AppTheme.cardRadius,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$1,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.$2,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
      ],
    );
  }
}

class _SelectedExperience extends StatelessWidget {
  final List<Experience> experience;

  const _SelectedExperience({required this.experience});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HomeSectionHeader(
          title: 'Selected Experience',
          subtitle:
              'Companies and products across a long-running mobile software career.',
          actionLabel: 'View Full Experience →',
          onAction: () => Navigator.of(context).pushNamed('/experience'),
        ),
        const SizedBox(height: 20),
        ...experience.map(
          (item) => Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.outline)),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 700;
                final company = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.company,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.title} · ${item.period}',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                );
                final detail = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.summary,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (item.tech.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      PortfolioTagWrap(
                        tags: item.tech.take(4).toList(growable: false),
                      ),
                    ],
                  ],
                );
                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 320, child: company),
                          const SizedBox(width: 28),
                          Expanded(child: detail),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          company,
                          const SizedBox(height: 12),
                          detail,
                        ],
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _PdfCallout extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onPortfolio;

  const _PdfCallout({required this.onResume, required this.onPortfolio});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLow.withValues(alpha: 0.92),
        border: Border.all(color: AppTheme.outline),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 16,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 560,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Prefer a physical copy?',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  'Resume emphasizes professional experience. Engineering Portfolio emphasizes featured projects and case-study context.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Wrap(
            spacing: 10,
            children: [
              FilledButton(
                onPressed: onResume,
                child: const Text('Download Resume'),
              ),
              OutlinedButton(
                onPressed: onPortfolio,
                child: const Text('Portfolio PDF'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactFooter extends StatelessWidget {
  final PortfolioData data;

  const _ContactFooter({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: AppTheme.outline),
        const SizedBox(height: 28),
        Text(
          data.contact.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            data.contact.body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 18,
          runSpacing: 8,
          children: [
            Text(
              data.site.email,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            if ((data.contact.phone ?? '').isNotEmpty)
              Text(
                'Tel: ${data.contact.phone}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            if ((data.contact.lineId ?? '').isNotEmpty)
              Text(
                'LINE: ${data.contact.lineId}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton(
              onPressed: () => launchPortfolioUrl(data.contact.ctaUrl),
              child: Text(data.contact.ctaLabel),
            ),
            ...data.socialLinks.map(
              (item) => TextButton(
                onPressed: () => launchPortfolioUrl(item.url),
                child: Text(item.label),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          '© ${DateTime.now().year} ${data.site.ownerName} · Built with Flutter.',
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}

class _HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _HomeSectionHeader({
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            if (actionLabel != null)
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        ],
        const SizedBox(height: 14),
        const Divider(height: 1, color: AppTheme.outline),
      ],
    );
  }
}
