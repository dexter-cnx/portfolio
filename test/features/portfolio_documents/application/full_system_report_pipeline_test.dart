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
        name: 'pdf-other',
        summary: 'Other PDF project',
        repoUrl: 'https://github.com/dexter-cnx/pdf-other',
        liveUrl: '',
        images: const [],
        tags: const ['Flutter'],
      ),
    ],
  );

  test('compact export uses PDF selection and featured policy end to end', () {
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
    final projects = plan.payload['projects'] as List<dynamic>;

    expect(document.projects, hasLength(2));
    expect(
      document.projects.map((project) => project.name),
      <String>['pdf-featured', 'pdf-other'],
    );
    expect(projects, hasLength(1));
    expect((projects.single as Map<String, dynamic>)['name'], 'pdf-featured');
    expect((projects.single as Map<String, dynamic>)['description'], '');
    expect(
      composition.map((section) => section.definition.id),
      <PortfolioReportSectionId>[
        PortfolioReportSectionId.summary,
        PortfolioReportSectionId.experience,
        PortfolioReportSectionId.skills,
        PortfolioReportSectionId.projects,
        PortfolioReportSectionId.links,
      ],
    );
  });

  test('full Thai export keeps all selected PDF projects and descriptions', () {
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
    final projects = plan.payload['projects'] as List<dynamic>;
    final projectSection = composition.singleWhere(
      (section) => section.definition.id == PortfolioReportSectionId.projects,
    );

    expect(document.locale, 'th');
    expect(projects, hasLength(2));
    expect(
      (projects.first as Map<String, dynamic>)['description'],
      'Featured project description.',
    );
    expect(projectSection.value, same(projects));
    expect(
      projects.map((project) => (project as Map<String, dynamic>)['name']),
      <String>['pdf-featured', 'pdf-other'],
    );
  });
}
