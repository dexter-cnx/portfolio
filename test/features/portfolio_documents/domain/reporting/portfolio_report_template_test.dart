import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/reporting/portfolio_report_template.dart';

void main() {
  const registry = PortfolioReportTemplateRegistry();

  test('portfolio prioritizes featured projects before experience', () {
    final definition = registry.definitionFor(
      PortfolioReportTemplateId.portfolioFull,
    );

    expect(
      definition.sections.map((section) => section.dataExpression),
      <String>[
        'summary',
        'featuredProjects',
        'experience',
        'skills',
        'openSourceProjects',
        'links',
      ],
    );
  });

  test('resume prioritizes experience and keeps open source compact', () {
    final definition = registry.definitionFor(
      PortfolioReportTemplateId.resumeCompact,
    );

    expect(
      definition.sections.map((section) => section.dataExpression),
      <String>[
        'summary',
        'experience',
        'featuredProjects',
        'skills',
        'openSourceProjects',
        'links',
      ],
    );
  });

  test('preserves template policies while using distinct section order', () {
    final full = registry.definitionFor(
      PortfolioReportTemplateId.portfolioFull,
    );
    final compact = registry.definitionFor(
      PortfolioReportTemplateId.resumeCompact,
    );

    expect(compact.sections, isNot(same(full.sections)));
    expect(full.featuredProjectsOnly, isFalse);
    expect(full.includeProjectDescriptions, isTrue);
    expect(compact.featuredProjectsOnly, isFalse);
    expect(compact.includeProjectDescriptions, isFalse);
  });
}
