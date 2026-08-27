import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio/models/portfolio_data_with_export_selection.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio/models/portfolio_models.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_document_mapper.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_render_plan.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_section_composition.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/reporting/portfolio_report_template.dart';

void main() {
  final fallback = PortfolioData.empty();
  final source = PortfolioDataWithExportSelection(
    site: fallback.site,
    hero: fallback.hero,
    about: fallback.about,
    experience: fallback.experience,
    featuredProjects: [
      FeaturedProject(
        name: 'visible-only',
        summary: 'Visible on site only',
        longDescription: 'Should not be exported.',
        repoUrl: 'https://github.com/dexter-cnx/visible-only',
        liveUrl: '',
        images: const [],
        urls: const [],
        tags: const ['Flutter'],
      ),
    ],
    otherProjects: const [],
    openSourceProjects: const [],
    contact: fallback.contact,
    socialLinks: fallback.socialLinks,
    nav: fallback.nav,
    pdfFeaturedProjects: [
      FeaturedProject(
        name: 'pdf-featured',
        summary: 'Featured PDF project',
        longDescription: 'Featured project description.',
        repoUrl: 'https://github.com/dexter-cnx/pdf-featured',
        liveUrl: '',
        images: const [],
        urls: const [],
        tags: const ['Dart', 'Rust'],
      ),
    ],
    pdfOtherProjects: [
      OtherProject(
        name: 'pdf-open-source',
        summary: 'Open source PDF project',
        repoUrl: 'https://github.com/dexter-cnx/pdf-open-source',
        liveUrl: '',
        images: const [],
        tags: const ['Flutter'],
      ),
    ],
  );

  test('compact export keeps featured and open source sections end to end', () {
    final document = const PortfolioDocumentMapper().map(
      source,
      locale: 'en',
      generatedAt: DateTime.utc(2026, 8, 27),
    );
    final plan = const PortfolioReportRenderPlanBuilder().build(
      document,
      template: PortfolioReportTemplateId.resumeCompact,
    );
    final composition = const PortfolioReportSectionCompositionBuilder().build(
      plan,
    );
    final featuredProjects = plan.payload['featuredProjects'] as List<dynamic>;
    final openSourceProjects =
        plan.payload['openSourceProjects'] as List<dynamic>;

    expect(document.projects, hasLength(2));
    expect(document.projects.map((project) => project.name), <String>[
      'pdf-featured',
      'pdf-open-source',
    ]);
    expect(featuredProjects, hasLength(1));
    expect(openSourceProjects, hasLength(1));
    expect(
      (featuredProjects.single as Map<String, dynamic>)['description'],
      '',
    );
    expect(
      composition.map((section) => section.definition.dataExpression),
      <String>[
        'summary',
        'experience',
        'skills',
        'featuredProjects',
        'openSourceProjects',
        'links',
      ],
    );
  });

  test('full Thai export keeps separate project groups and descriptions', () {
    final document = const PortfolioDocumentMapper().map(
      source,
      locale: 'th',
      generatedAt: DateTime.utc(2026, 8, 27),
    );
    final plan = const PortfolioReportRenderPlanBuilder().build(
      document,
      template: PortfolioReportTemplateId.portfolioFull,
    );
    final composition = const PortfolioReportSectionCompositionBuilder().build(
      plan,
    );
    final featuredProjects = plan.payload['featuredProjects'] as List<dynamic>;
    final openSourceProjects =
        plan.payload['openSourceProjects'] as List<dynamic>;
    final featuredSection = composition.singleWhere(
      (section) => section.definition.dataExpression == 'featuredProjects',
    );
    final openSourceSection = composition.singleWhere(
      (section) => section.definition.dataExpression == 'openSourceProjects',
    );

    expect(document.locale, 'th');
    expect(plan.payload['locale'], 'th');
    expect(featuredProjects, hasLength(1));
    expect(openSourceProjects, hasLength(1));
    expect(
      (featuredProjects.first as Map<String, dynamic>)['description'],
      'Featured project description.',
    );
    expect(featuredSection.value, same(featuredProjects));
    expect(openSourceSection.value, same(openSourceProjects));
  });
}
