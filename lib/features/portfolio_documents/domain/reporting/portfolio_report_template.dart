import 'dart:typed_data';

import '../entities/portfolio_document_data.dart';

enum PortfolioReportTemplateId {
  portfolioFull('portfolio_full'),
  resumeCompact('resume_compact');

  const PortfolioReportTemplateId(this.value);

  final String value;
}

final class PortfolioReportTemplateDefinition {
  const PortfolioReportTemplateDefinition({
    required this.id,
    required this.featuredProjectsOnly,
    required this.includeProjectDescriptions,
  });

  final PortfolioReportTemplateId id;
  final bool featuredProjectsOnly;
  final bool includeProjectDescriptions;
}

final class PortfolioReportTemplateRegistry {
  const PortfolioReportTemplateRegistry();

  PortfolioReportTemplateDefinition definitionFor(
    PortfolioReportTemplateId id,
  ) {
    return switch (id) {
      PortfolioReportTemplateId.portfolioFull =>
        const PortfolioReportTemplateDefinition(
          id: PortfolioReportTemplateId.portfolioFull,
          featuredProjectsOnly: false,
          includeProjectDescriptions: true,
        ),
      PortfolioReportTemplateId.resumeCompact =>
        const PortfolioReportTemplateDefinition(
          id: PortfolioReportTemplateId.resumeCompact,
          featuredProjectsOnly: true,
          includeProjectDescriptions: false,
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
