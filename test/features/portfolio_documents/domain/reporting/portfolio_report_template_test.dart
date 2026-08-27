import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/reporting/portfolio_report_template.dart';

void main() {
  const registry = PortfolioReportTemplateRegistry();

  test('defines stable section ordering and expressions', () {
    final definition = registry.definitionFor(
      PortfolioReportTemplateId.portfolioFull,
    );

    expect(
      definition.sections.map((section) => section.id),
      <PortfolioReportSectionId>[
        PortfolioReportSectionId.summary,
        PortfolioReportSectionId.experience,
        PortfolioReportSectionId.skills,
        PortfolioReportSectionId.projects,
        PortfolioReportSectionId.projects,
        PortfolioReportSectionId.links,
      ],
    );
    expect(
      definition.sections.map((section) => section.dataExpression),
      <String>[
        'summary',
        'experience',
        'skills',
        'featuredProjects',
        'openSourceProjects',
        'links',
      ],
    );
    expect(
      definition.sections.map((section) => section.labelKey),
      <String>[
        'summary',
        'experience',
        'skills',
        'featured_projects',
        'open_source_projects',
        'links',
      ],
    );
  });

  test('shares section metadata while preserving template policies', () {
    final full = registry.definitionFor(
      PortfolioReportTemplateId.portfolioFull,
    );
    final compact = registry.definitionFor(
      PortfolioReportTemplateId.resumeCompact,
    );

    expect(compact.sections, same(full.sections));
    expect(full.featuredProjectsOnly, isFalse);
    expect(full.includeProjectDescriptions, isTrue);
    expect(compact.featuredProjectsOnly, isFalse);
    expect(compact.includeProjectDescriptions, isFalse);
  });
}
