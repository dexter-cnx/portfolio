import 'dart:typed_data';

import '../entities/portfolio_document_data.dart';

enum PortfolioReportTemplateId {
  portfolioFull('portfolio_full'),
  resumeCompact('resume_compact');

  const PortfolioReportTemplateId(this.value);

  final String value;
}

enum PortfolioReportSectionId { summary, experience, skills, projects, links }

final class PortfolioReportSectionDefinition {
  const PortfolioReportSectionDefinition({
    required this.id,
    required this.labelKey,
    required this.dataExpression,
  });

  final PortfolioReportSectionId id;
  final String labelKey;
  final String dataExpression;
}

final class PortfolioReportTemplateDefinition {
  const PortfolioReportTemplateDefinition({
    required this.id,
    required this.featuredProjectsOnly,
    required this.includeProjectDescriptions,
    required this.sections,
  });

  final PortfolioReportTemplateId id;
  final bool featuredProjectsOnly;
  final bool includeProjectDescriptions;
  final List<PortfolioReportSectionDefinition> sections;
}

final class PortfolioReportTemplateRegistry {
  const PortfolioReportTemplateRegistry({
    this.overrides =
        const <PortfolioReportTemplateId, PortfolioReportTemplateDefinition>{},
  });

  final Map<PortfolioReportTemplateId, PortfolioReportTemplateDefinition>
  overrides;

  static const _standardSections = <PortfolioReportSectionDefinition>[
    PortfolioReportSectionDefinition(
      id: PortfolioReportSectionId.summary,
      labelKey: 'summary',
      dataExpression: 'summary',
    ),
    PortfolioReportSectionDefinition(
      id: PortfolioReportSectionId.experience,
      labelKey: 'experience',
      dataExpression: 'experience',
    ),
    PortfolioReportSectionDefinition(
      id: PortfolioReportSectionId.skills,
      labelKey: 'skills',
      dataExpression: 'skills',
    ),
    PortfolioReportSectionDefinition(
      id: PortfolioReportSectionId.projects,
      labelKey: 'projects',
      dataExpression: 'projects',
    ),
    PortfolioReportSectionDefinition(
      id: PortfolioReportSectionId.links,
      labelKey: 'links',
      dataExpression: 'links',
    ),
  ];

  PortfolioReportTemplateDefinition definitionFor(
    PortfolioReportTemplateId id,
  ) {
    final override = overrides[id];
    if (override != null) return override;

    return switch (id) {
      PortfolioReportTemplateId.portfolioFull =>
        const PortfolioReportTemplateDefinition(
          id: PortfolioReportTemplateId.portfolioFull,
          featuredProjectsOnly: false,
          includeProjectDescriptions: true,
          sections: _standardSections,
        ),
      PortfolioReportTemplateId.resumeCompact =>
        const PortfolioReportTemplateDefinition(
          id: PortfolioReportTemplateId.resumeCompact,
          featuredProjectsOnly: false,
          includeProjectDescriptions: false,
          sections: _standardSections,
        ),
    };
  }
}

abstract interface class PortfolioReportRenderer {
  Future<Uint8List> render(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  });
}
