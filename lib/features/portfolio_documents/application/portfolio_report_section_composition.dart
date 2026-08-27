import '../domain/reporting/portfolio_report_template.dart';
import 'portfolio_report_render_plan.dart';
import 'portfolio_report_value_resolver.dart';

final class PortfolioReportSectionComposition {
  const PortfolioReportSectionComposition({
    required this.definition,
    required this.value,
  });

  final PortfolioReportSectionDefinition definition;
  final dynamic value;
}

final class PortfolioReportSectionCompositionBuilder {
  const PortfolioReportSectionCompositionBuilder({
    this.valueResolver = const PortfolioReportValueResolver(),
  });

  final PortfolioReportValueResolver valueResolver;

  List<PortfolioReportSectionComposition> build(
    PortfolioReportRenderPlan plan,
  ) {
    return plan.template.sections
        .map(
          (section) => PortfolioReportSectionComposition(
            definition: section,
            value: valueResolver.resolve(section.dataExpression, plan.payload),
          ),
        )
        .toList(growable: false);
  }
}
