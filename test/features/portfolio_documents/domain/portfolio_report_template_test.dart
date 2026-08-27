import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/reporting/portfolio_report_template.dart';

void main() {
  test('report template ids stay stable for report integrations', () {
    expect(PortfolioReportTemplateId.portfolioFull.value, 'portfolio_full');
    expect(PortfolioReportTemplateId.resumeCompact.value, 'resume_compact');
  });
}
