import '../domain/entities/portfolio_document_data.dart';
import '../domain/reporting/portfolio_report_template.dart';
import 'portfolio_report_payload_adapter.dart';

final class PortfolioReportRenderPlan {
  const PortfolioReportRenderPlan({
    required this.template,
    required this.payload,
  });

  final PortfolioReportTemplateDefinition template;
  final Map<String, dynamic> payload;
}

final class PortfolioReportRenderPlanBuilder {
  const PortfolioReportRenderPlanBuilder({
    this.payloadAdapter = const PortfolioReportPayloadAdapter(),
    this.templateRegistry = const PortfolioReportTemplateRegistry(),
  });

  final PortfolioReportPayloadAdapter payloadAdapter;
  final PortfolioReportTemplateRegistry templateRegistry;

  PortfolioReportRenderPlan build(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  }) {
    final definition = templateRegistry.definitionFor(template);
    final payload = payloadAdapter.adapt(data);
    final projects = (payload['projects'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .where(
          (project) =>
              !definition.featuredProjectsOnly || project['featured'] == true,
        )
        .map(
          (project) => <String, dynamic>{
            ...project,
            if (!definition.includeProjectDescriptions) 'description': '',
          },
        )
        .toList(growable: false);
    final featuredProjects = projects
        .where((project) => project['featured'] == true)
        .toList(growable: false);
    final openSourceProjects = projects
        .where((project) => project['featured'] != true)
        .toList(growable: false);

    return PortfolioReportRenderPlan(
      template: definition,
      payload: <String, dynamic>{
        ...payload,
        'projects': projects,
        'featuredProjects': featuredProjects,
        'openSourceProjects': openSourceProjects,
      },
    );
  }
}
