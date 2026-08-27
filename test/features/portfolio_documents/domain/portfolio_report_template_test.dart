import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/reporting/portfolio_report_template.dart';

void main() {
  test('report template ids stay stable for report integrations', () {
    expect(PortfolioReportTemplateId.portfolioFull.value, 'portfolio_full');
    expect(PortfolioReportTemplateId.resumeCompact.value, 'resume_compact');
  });

  test('template registry keeps full and compact policies distinct', () {
    const registry = PortfolioReportTemplateRegistry();

    final full = registry.definitionFor(
      PortfolioReportTemplateId.portfolioFull,
    );
    final compact = registry.definitionFor(
      PortfolioReportTemplateId.resumeCompact,
    );

    expect(full.featuredProjectsOnly, isFalse);
    expect(full.includeProjectDescriptions, isTrue);
    expect(compact.featuredProjectsOnly, isTrue);
    expect(compact.includeProjectDescriptions, isFalse);
  });
}
