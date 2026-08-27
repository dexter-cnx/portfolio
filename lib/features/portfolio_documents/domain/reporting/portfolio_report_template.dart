import 'dart:typed_data';

import '../entities/portfolio_document_data.dart';

enum PortfolioReportTemplateId {
  portfolioFull('portfolio_full'),
  resumeCompact('resume_compact');

  const PortfolioReportTemplateId(this.value);

  final String value;
}

abstract interface class PortfolioReportRenderer {
  Future<Uint8List> render(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  });
}
