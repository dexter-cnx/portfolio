import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_render_plan.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/entities/portfolio_document_data.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/reporting/portfolio_report_template.dart';

void main() {
  final data = PortfolioDocumentData(
    locale: 'en',
    profile: const PortfolioDocumentProfile(
      name: 'Dexter',
      role: 'Flutter Developer',
      location: 'Chiang Mai',
      email: 'dexter@example.com',
      phone: '',
    ),
    summary: const ['Summary'],
    skills: const ['Flutter'],
    experience: const [],
    projects: const [
      PortfolioDocumentProject(
        name: 'featured',
        summary: 'Featured summary',
        description: 'Featured description',
        repositoryUrl: 'https://example.com/featured',
        liveUrl: '',
        tags: [],
        links: [],
        featured: true,
      ),
      PortfolioDocumentProject(
        name: 'other',
        summary: 'Other summary',
        description: 'Other description',
        repositoryUrl: 'https://example.com/other',
        liveUrl: '',
        tags: [],
        links: [],
        featured: false,
      ),
    ],
    links: const [],
    generatedAt: DateTime.utc(2026, 8, 27),
  );

  test('compact plan filters projects and strips descriptions', () {
    final plan = const PortfolioReportRenderPlanBuilder().build(
      data,
      template: PortfolioReportTemplateId.resumeCompact,
    );
    final projects = plan.payload['projects'] as List<dynamic>;

    expect(plan.template.id, PortfolioReportTemplateId.resumeCompact);
    expect(projects, hasLength(1));
    expect((projects.first as Map<String, dynamic>)['name'], 'featured');
    expect((projects.first as Map<String, dynamic>)['description'], '');
  });

  test('full plan keeps all projects and descriptions', () {
    final plan = const PortfolioReportRenderPlanBuilder().build(
      data,
      template: PortfolioReportTemplateId.portfolioFull,
    );
    final projects = plan.payload['projects'] as List<dynamic>;

    expect(plan.template.id, PortfolioReportTemplateId.portfolioFull);
    expect(projects, hasLength(2));
    expect(
      (projects.first as Map<String, dynamic>)['description'],
      'Featured description',
    );
  });
}
