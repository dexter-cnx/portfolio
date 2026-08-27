import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../portfolio_documents/application/portfolio_document_mapper.dart';
import '../../../portfolio_documents/application/portfolio_report_render_plan.dart';
import '../../../portfolio_documents/domain/entities/portfolio_document_data.dart';
import '../../../portfolio_documents/domain/reporting/portfolio_report_template.dart';
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
  }) : _renderPlanBuilder = renderPlanBuilder;

  final PortfolioReportRenderPlanBuilder _renderPlanBuilder;

  @override
  Future<Uint8List> render(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  }) async {
    final plan = _renderPlanBuilder.build(data, template: template);
    final payload = plan.payload;
    final locale = payload['locale']?.toString() ?? 'en';
    final profile = _map(payload['profile']);
    final summary = _strings(payload['summary']);
    final experience = _maps(payload['experience']);
    final skills = _strings(payload['skills']);
    final projects = _maps(payload['projects']);
    final links = _maps(payload['links']);
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
    final labels = _labelsFor(locale);
    final dateStr = generatedAt == null
        ? ''
        : '${generatedAt.day}/${generatedAt.month}/${generatedAt.year}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (_) => <pw.Widget>[
          _header(profile),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          _sectionTitle(labels.summary),
          pw.Text(
            summary.join('\n\n'),
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle(labels.experience),
          ...experience.map(_experience),
          _sectionTitle(labels.skills),
          pw.Wrap(
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
                    child: pw.Text(
                      skill,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  ),
                )
                .toList(),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle(labels.projects),
          ...projects.map((project) => _project(project, labels)),
          pw.SizedBox(height: 20),
          _sectionTitle(labels.links),
          ...links.map(_link),
          pw.Spacer(),
          pw.Divider(thickness: 0.5, color: PdfColors.grey300),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                labels.generated,
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey500,
                ),
              ),
              if (dateStr.isNotEmpty)
                pw.Text(
                  'Date: $dateStr',
                  style: const pw.TextStyle(
                    fontSize: 8,
                    color: PdfColors.grey500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
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

  pw.Widget _project(Map<String, dynamic> project, _ResumeLabels labels) {
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
      child: pw.Row(
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
          pw.Text(
            url,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue700),
          ),
        ],
      ),
    );
  }

  _ResumeLabels _labelsFor(String locale) {
    if (locale == 'th') {
      return const _ResumeLabels(
        summary: 'สรุป',
        experience: 'ประสบการณ์การทำงาน',
        skills: 'ทักษะทางเทคนิค',
        projects: 'ผลงาน',
        techStack: 'เทคโนโลยีที่ใช้',
        generated: 'สร้างจากเว็บไซต์พอร์ตโฟลิโอ',
        links: 'ลิงก์และโซเชียล',
      );
    }
    return const _ResumeLabels(
      summary: 'Summary',
      experience: 'Experience',
      skills: 'Technical Skills',
      projects: 'Projects',
      techStack: 'Tech Stack',
      generated: 'Generated from Portfolio Website',
      links: 'Links & Social',
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 13,
            color: PdfColors.blueGrey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(height: 1.5, width: 40, color: PdfColors.blueGrey700),
        pw.SizedBox(height: 8),
      ],
    );
  }
}

final class _ResumeLabels {
  const _ResumeLabels({
    required this.summary,
    required this.experience,
    required this.skills,
    required this.projects,
    required this.techStack,
    required this.generated,
    required this.links,
  });

  final String summary;
  final String experience;
  final String skills;
  final String projects;
  final String techStack;
  final String generated;
  final String links;
}
