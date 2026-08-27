import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_render_plan.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_section_composition.dart';
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
    skills: const ['Flutter', 'Rust'],
    experience: const [],
    projects: const [],
    links: const [],
    generatedAt: DateTime.utc(2026, 8, 27),
  );

  test('composes sections in template order and resolves expressions', () {
    const definition = PortfolioReportTemplateDefinition(
      id: PortfolioReportTemplateId.portfolioFull,
      featuredProjectsOnly: false,
      includeProjectDescriptions: true,
      sections: <PortfolioReportSectionDefinition>[
        PortfolioReportSectionDefinition(
          id: PortfolioReportSectionId.skills,
          labelKey: 'skills',
          dataExpression: 'skills',
        ),
        PortfolioReportSectionDefinition(
          id: PortfolioReportSectionId.summary,
          labelKey: 'summary',
          dataExpression: 'summary',
        ),
      ],
    );
    const renderPlanBuilder = PortfolioReportRenderPlanBuilder(
      templateRegistry: PortfolioReportTemplateRegistry(
        overrides: <PortfolioReportTemplateId, PortfolioReportTemplateDefinition>{
          PortfolioReportTemplateId.portfolioFull: definition,
        },
      ),
    );

    final plan = renderPlanBuilder.build(
      data,
      template: PortfolioReportTemplateId.portfolioFull,
    );
    final composition = const PortfolioReportSectionCompositionBuilder().build(
      plan,
    );

    expect(
      composition.map((section) => section.definition.id),
      <PortfolioReportSectionId>[
        PortfolioReportSectionId.skills,
        PortfolioReportSectionId.summary,
      ],
    );
    expect(composition.first.value, <String>['Flutter', 'Rust']);
    expect(composition.last.value, <String>['Summary']);
    expect(
      composition.any(
        (section) => section.definition.id == PortfolioReportSectionId.links,
      ),
      isFalse,
    );
  });
}
