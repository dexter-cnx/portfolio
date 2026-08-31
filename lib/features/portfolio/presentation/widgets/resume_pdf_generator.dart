import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../portfolio_documents/application/portfolio_document_mapper.dart';
import '../../../portfolio_documents/application/portfolio_report_render_plan.dart';
import '../../../portfolio_documents/application/portfolio_report_section_composition.dart';
import '../../../portfolio_documents/domain/entities/portfolio_document_data.dart';
import '../../../portfolio_documents/domain/reporting/portfolio_report_template.dart';
import '../../../portfolio_documents/presentation/pdf/portfolio_pdf_components.dart';
import '../../../portfolio_documents/presentation/pdf/portfolio_pdf_labels.dart';
import '../../models/portfolio_models.dart';

class ResumePdfGenerator {
  static const PortfolioReportTemplateId defaultTemplate =
      PortfolioReportTemplateId.resumeCompact;
  static const String portfolioUrl = 'https://dexter-cnx.github.io/portfolio/';

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
      PortfolioReportTemplateId.portfolioFull => 'Engineering_Portfolio',
      PortfolioReportTemplateId.resumeCompact => 'Resume',
    };
    return '${data.profile.name}_$suffix.pdf';
  }
}

final class PortfolioPdfRenderer implements PortfolioReportRenderer {
  PortfolioPdfRenderer({
    PortfolioReportRenderPlanBuilder renderPlanBuilder =
        const PortfolioReportRenderPlanBuilder(),
    PortfolioReportSectionCompositionBuilder sectionCompositionBuilder =
        const PortfolioReportSectionCompositionBuilder(),
    PortfolioPdfComponents components = const PortfolioPdfComponents(),
    PortfolioPdfLabelCatalog labelCatalog = const PortfolioPdfLabelCatalog(),
  }) : _renderPlanBuilder = renderPlanBuilder,
       _sectionCompositionBuilder = sectionCompositionBuilder,
       _components = components,
       _labelCatalog = labelCatalog;

  final PortfolioReportRenderPlanBuilder _renderPlanBuilder;
  final PortfolioReportSectionCompositionBuilder _sectionCompositionBuilder;
  final PortfolioPdfComponents _components;
  final PortfolioPdfLabelCatalog _labelCatalog;

  @override
  Future<Uint8List> render(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  }) async {
    final plan = _renderPlanBuilder.build(data, template: template);
    final payload = plan.payload;
    final sections = _sectionCompositionBuilder.build(plan);
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
          _header(profile, template),
          pw.SizedBox(height: 14),
          for (final entry in sections.indexed) ...[
            if (entry.$1 > 0) pw.SizedBox(height: 18),
            ..._renderSection(entry.$2, labels, template),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  List<pw.Widget> _renderSection(
    PortfolioReportSectionComposition section,
    PortfolioPdfLabels labels,
    PortfolioReportTemplateId template,
  ) {
    final definition = section.definition;
    final value = section.value;
    final title = labels.forKey(definition.labelKey);
    final isFeatured = definition.dataExpression == 'featuredProjects';
    final isOpenSource = definition.dataExpression == 'openSourceProjects';

    final content = switch (definition.id) {
      PortfolioReportSectionId.summary => <pw.Widget>[
        pw.Text(
          _strings(value).join('\n\n'),
          style: const pw.TextStyle(fontSize: 10.5, lineSpacing: 1.35),
        ),
      ],
      PortfolioReportSectionId.experience =>
        _maps(value)
            .map(
              (item) => _experience(
                item,
                prominent: template == PortfolioReportTemplateId.resumeCompact,
              ),
            )
            .toList(growable: false),
      PortfolioReportSectionId.skills => <pw.Widget>[_skills(_strings(value))],
      PortfolioReportSectionId.projects =>
        _maps(value)
            .map(
              (project) => _project(
                project,
                labels,
                prominent:
                    isFeatured &&
                    template == PortfolioReportTemplateId.portfolioFull,
                compact: isOpenSource,
              ),
            )
            .toList(growable: false),
      PortfolioReportSectionId.links => _maps(
        value,
      ).map(_link).toList(growable: false),
    };

    return <pw.Widget>[_components.sectionTitle(title), ...content];
  }

  pw.Widget _header(
    Map<String, dynamic> profile,
    PortfolioReportTemplateId template,
  ) {
    final name = profile['name']?.toString() ?? '';
    final role = profile['role']?.toString() ?? '';
    final email = profile['email']?.toString() ?? '';
    final location = profile['location']?.toString() ?? '';
    final phone = profile['phone']?.toString() ?? '';
    final documentTitle = switch (template) {
      PortfolioReportTemplateId.resumeCompact => 'RESUME',
      PortfolioReportTemplateId.portfolioFull => 'ENGINEERING PORTFOLIO',
    };

    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 12),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blueGrey300, width: 1),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  documentTitle,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 9,
                    color: PdfColors.blueGrey600,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  name,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                pw.Text(
                  role,
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 10,
                  runSpacing: 3,
                  children: [
                    if (email.isNotEmpty)
                      pw.Text(email, style: const pw.TextStyle(fontSize: 9)),
                    if (phone.isNotEmpty)
                      pw.Text(phone, style: const pw.TextStyle(fontSize: 9)),
                    if (location.isNotEmpty)
                      pw.Text(location, style: const pw.TextStyle(fontSize: 9)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.UrlLink(
                  destination: ResumePdfGenerator.portfolioUrl,
                  child: pw.Text(
                    ResumePdfGenerator.portfolioUrl,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.blue700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(width: 18),
          pw.Column(
            children: [
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: ResumePdfGenerator.portfolioUrl,
                width: 58,
                height: 58,
                drawText: false,
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'PORTFOLIO',
                style: const pw.TextStyle(
                  fontSize: 7,
                  color: PdfColors.grey600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _experience(Map<String, dynamic> item, {required bool prominent}) {
    final company = item['company']?.toString() ?? '';
    final title = item['title']?.toString() ?? '';
    final period = item['period']?.toString() ?? '';
    final summary = item['summary']?.toString() ?? '';
    final highlights = _strings(item['highlights']);
    final tech = _strings(item['tech']);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: prominent
          ? const pw.EdgeInsets.all(10)
          : const pw.EdgeInsets.symmetric(vertical: 2),
      decoration: prominent
          ? const pw.BoxDecoration(
              color: PdfColors.grey100,
              border: pw.Border(
                left: pw.BorderSide(color: PdfColors.blueGrey600, width: 2),
              ),
            )
          : null,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Text(
                  company,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: prominent ? 12.5 : 12,
                  ),
                ),
              ),
              pw.Text(
                period,
                style: const pw.TextStyle(
                  fontSize: 9.5,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10.5, fontStyle: pw.FontStyle.italic),
          ),
          if (summary.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(summary, style: const pw.TextStyle(fontSize: 9.5)),
          ],
          if (highlights.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            ...highlights.map(
              (highlight) => pw.Bullet(
                text: highlight,
                style: const pw.TextStyle(fontSize: 9.5),
              ),
            ),
          ],
          if (tech.isNotEmpty) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              tech.join(' · '),
              style: const pw.TextStyle(
                fontSize: 8.5,
                color: PdfColors.blueGrey600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _project(
    Map<String, dynamic> project,
    PortfolioPdfLabels labels, {
    required bool prominent,
    required bool compact,
  }) {
    final name = project['name']?.toString() ?? '';
    final summary = project['summary']?.toString() ?? '';
    final description = project['description']?.toString() ?? '';
    final repositoryUrl = project['repositoryUrl']?.toString() ?? '';
    final liveUrl = project['liveUrl']?.toString() ?? '';
    final tags = _strings(project['tags']);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 9),
      padding: prominent
          ? const pw.EdgeInsets.all(11)
          : const pw.EdgeInsets.symmetric(vertical: 2),
      decoration: prominent
          ? pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.blueGrey200),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            )
          : null,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            name,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: prominent ? 12.5 : 10.5,
            ),
          ),
          if (summary.isNotEmpty)
            pw.Text(
              summary,
              style: pw.TextStyle(fontSize: compact ? 8.8 : 9.5),
            ),
          if (!compact && description.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              description,
              style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
            ),
          ],
          if (tags.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              '${labels.techStack}: ${tags.join(', ')}',
              style: const pw.TextStyle(
                fontSize: 8.5,
                color: PdfColors.blueGrey600,
              ),
            ),
          ],
          if (prominent &&
              (repositoryUrl.isNotEmpty || liveUrl.isNotEmpty)) ...[
            pw.SizedBox(height: 4),
            if (repositoryUrl.isNotEmpty)
              _components.externalLink(label: 'GitHub', url: repositoryUrl),
            if (liveUrl.isNotEmpty)
              _components.externalLink(label: 'Project', url: liveUrl),
          ],
        ],
      ),
    );
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

  pw.Widget _link(Map<String, dynamic> link) {
    final label = link['label']?.toString() ?? '';
    final url = link['url']?.toString() ?? '';
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: _components.externalLink(label: label, url: url),
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
}
