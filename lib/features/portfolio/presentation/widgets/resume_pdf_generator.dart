import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../portfolio_documents/application/portfolio_document_mapper.dart';
import '../../../portfolio_documents/application/portfolio_report_render_plan.dart';
import '../../../portfolio_documents/application/portfolio_report_value_resolver.dart';
import '../../../portfolio_documents/domain/entities/portfolio_document_data.dart';
import '../../../portfolio_documents/domain/reporting/portfolio_report_template.dart';
import '../../../portfolio_documents/presentation/pdf/portfolio_pdf_components.dart';
import '../../../portfolio_documents/presentation/pdf/portfolio_pdf_labels.dart';
import '../../models/portfolio_models.dart';

class ResumePdfGenerator {
  static const PortfolioReportTemplateId defaultTemplate =
      PortfolioReportTemplateId.resumeCompact;

  static Future<void> generateAndDownload(
    PortfolioData data,
    String locale, {
    PortfolioReportTemplateId template = defaultTemplate,
  }) async {
    final documentData = const PortfolioDocumentMapper().map(
      data,
      locale: locale,
    );
    await generateDocument(documentData, template: template);
  }

  static Future<void> generateDocument(
    PortfolioDocumentData data, {
    PortfolioReportTemplateId template = defaultTemplate,
  }) async {
    final renderer = PortfolioPdfRenderer();
    final bytes = await renderer.render(data, template: template);
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: _fileName(data, template),
    );
  }

  static String _fileName(
    PortfolioDocumentData data,
    PortfolioReportTemplateId template,
  ) {
    final suffix = switch (template) {
      PortfolioReportTemplateId.portfolioFull => 'Portfolio',
      PortfolioReportTemplateId.resumeCompact => 'Resume',
    };
    return '${data.profile.name}_$suffix.pdf';
  }
}

final class PortfolioPdfRenderer implements PortfolioReportRenderer {
  PortfolioPdfRenderer({
    PortfolioReportRenderPlanBuilder renderPlanBuilder =
        const PortfolioReportRenderPlanBuilder(),
    PortfolioReportValueResolver valueResolver =
        const PortfolioReportValueResolver(),
    PortfolioPdfComponents components = const PortfolioPdfComponents(),
    PortfolioPdfLabelCatalog labelCatalog = const PortfolioPdfLabelCatalog(),
  }) : _renderPlanBuilder = renderPlanBuilder,
       _valueResolver = valueResolver,
       _components = components,
       _labelCatalog = labelCatalog;

  final PortfolioReportRenderPlanBuilder _renderPlanBuilder;
  final PortfolioReportValueResolver _valueResolver;
  final PortfolioPdfComponents _components;
  final PortfolioPdfLabelCatalog _labelCatalog;

  @override
  Future<Uint8List> render(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  }) async {
    final plan = _renderPlanBuilder.build(data, template: template);
    final payload = plan.payload;
    final locale = payload['locale']?.toString() ?? 'en';
    final profile = _map(payload['profile']);
    final generatedAt = DateTime.tryParse(
      payload['generatedAt']?.toString() ?? '',
    )?.toLocal();

    final pdf = pw.Document();
    final isThai = locale == 'th';
    final font = isThai
        ? await PdfGoogleFonts.notoSansThaiRegular()
        : await PdfGoogleFonts.interRegular();
    final fontBold = isThai
        ? await PdfGoogleFonts.notoSansThaiBold()
        : await PdfGoogleFonts.interBold();
    final labels = _labelCatalog.forLocale(locale);
    final dateStr = generatedAt == null
        ? ''
        : '${generatedAt.day}/${generatedAt.month}/${generatedAt.year}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        footer: (context) => _components.footer(
          context: context,
          generatedLabel: labels.generated,
          dateText: dateStr.isEmpty ? '' : 'Date: $dateStr',
        ),
        build: (_) => <pw.Widget>[
          _header(profile),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          for (final entry in plan.template.sections.indexed) ...[
            if (entry.$1 > 0) pw.SizedBox(height: 20),
            ..._renderSection(entry.$2, payload, labels),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  List<pw.Widget> _renderSection(
    PortfolioReportSectionDefinition section,
    Map<String, dynamic> payload,
    PortfolioPdfLabels labels,
  ) {
    final value = _valueResolver.resolve(section.dataExpression, payload);
    final title = labels.forKey(section.labelKey);

    final content = switch (section.id) {
      PortfolioReportSectionId.summary => <pw.Widget>[
        pw.Text(
          _strings(value).join('\n\n'),
          style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
        ),
      ],
      PortfolioReportSectionId.experience => _maps(
        value,
      ).map(_experience).toList(growable: false),
      PortfolioReportSectionId.skills => <pw.Widget>[_skills(_strings(value))],
      PortfolioReportSectionId.projects => _maps(
        value,
      ).map((project) => _project(project, labels)).toList(growable: false),
      PortfolioReportSectionId.links => _maps(
        value,
      ).map(_link).toList(growable: false),
    };

    return <pw.Widget>[_components.sectionTitle(title), ...content];
  }

  pw.Widget _skills(List<String> skills) {
    return pw.Wrap(
      spacing: 5,
      runSpacing: 5,
      children: skills
          .map(
            (skill) => pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 4,
              ),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
              ),
              child: pw.Text(skill, style: const pw.TextStyle(fontSize: 9)),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> _map(dynamic value) {
    return value is Map<String, dynamic> ? value : const <String, dynamic>{};
  }

  List<Map<String, dynamic>> _maps(dynamic value) {
    return (value as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList(growable: false);
  }

  List<String> _strings(dynamic value) {
    return (value as List<dynamic>? ?? const [])
        .map((item) => item.toString())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
  }

  pw.Widget _header(Map<String, dynamic> profile) {
    final name = profile['name']?.toString() ?? '';
    final role = profile['role']?.toString() ?? '';
    final email = profile['email']?.toString() ?? '';
    final location = profile['location']?.toString() ?? '';
    final phone = profile['phone']?.toString() ?? '';

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              name,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
            ),
            pw.Text(
              role,
              style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            if (email.isNotEmpty)
              pw.Text(email, style: const pw.TextStyle(fontSize: 10)),
            if (location.isNotEmpty)
              pw.Text(location, style: const pw.TextStyle(fontSize: 10)),
            if (phone.isNotEmpty)
              pw.Text(phone, style: const pw.TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  pw.Widget _experience(Map<String, dynamic> item) {
    final company = item['company']?.toString() ?? '';
    final title = item['title']?.toString() ?? '';
    final period = item['period']?.toString() ?? '';
    final summary = item['summary']?.toString() ?? '';
    final highlights = _strings(item['highlights']);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              company,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.Text(
              period,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Text(
          title,
          style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
        ),
        pw.SizedBox(height: 4),
        pw.Text(summary, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 4),
        ...highlights.map(
          (highlight) => pw.Bullet(
            text: highlight,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _project(Map<String, dynamic> project, PortfolioPdfLabels labels) {
    final name = project['name']?.toString() ?? '';
    final summary = project['summary']?.toString() ?? '';
    final description = project['description']?.toString() ?? '';
    final tags = _strings(project['tags']);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          name,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
        ),
        pw.Text(summary, style: const pw.TextStyle(fontSize: 10)),
        if (description.isNotEmpty)
          pw.Text(description, style: const pw.TextStyle(fontSize: 9)),
        if (tags.isNotEmpty)
          pw.Text(
            '${labels.techStack}: ${tags.join(', ')}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _link(Map<String, dynamic> link) {
    final label = link['label']?.toString() ?? '';
    final url = link['url']?.toString() ?? '';

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: _components.externalLink(label: label, url: url),
    );
  }
}
