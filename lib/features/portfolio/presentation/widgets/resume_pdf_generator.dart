import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../portfolio_documents/application/portfolio_document_mapper.dart';
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
    PortfolioReportTemplateRegistry templateRegistry =
        const PortfolioReportTemplateRegistry(),
  }) : _templateRegistry = templateRegistry;

  final PortfolioReportTemplateRegistry _templateRegistry;

  @override
  Future<Uint8List> render(
    PortfolioDocumentData data, {
    required PortfolioReportTemplateId template,
  }) async {
    final definition = _templateRegistry.definitionFor(template);
    final pdf = pw.Document();
    final isThai = data.locale == 'th';
    final font = isThai
        ? await PdfGoogleFonts.notoSansThaiRegular()
        : await PdfGoogleFonts.interRegular();
    final fontBold = isThai
        ? await PdfGoogleFonts.notoSansThaiBold()
        : await PdfGoogleFonts.interBold();
    final labels = _labelsFor(data.locale);
    final projects = definition.featuredProjectsOnly
        ? data.projects
            .where((project) => project.featured)
            .toList(growable: false)
        : data.projects;
    final generatedAt = data.generatedAt.toLocal();
    final dateStr =
        '${generatedAt.day}/${generatedAt.month}/${generatedAt.year}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (_) => <pw.Widget>[
          _header(data),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          _sectionTitle(labels.summary),
          pw.Text(
            data.summary.join('\n\n'),
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle(labels.experience),
          ...data.experience.map(_experience),
          _sectionTitle(labels.skills),
          pw.Wrap(
            spacing: 5,
            runSpacing: 5,
            children: data.skills
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
          ...projects.map(
            (project) => _project(
              project,
              labels,
              includeDescription: definition.includeProjectDescriptions,
            ),
          ),
          pw.SizedBox(height: 20),
          _sectionTitle(labels.links),
          ...data.links.map(_link),
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

  pw.Widget _header(PortfolioDocumentData data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              data.profile.name,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
            ),
            pw.Text(
              data.profile.role,
              style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              data.profile.email,
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              data.profile.location,
              style: const pw.TextStyle(fontSize: 10),
            ),
            if (data.profile.phone.isNotEmpty)
              pw.Text(
                data.profile.phone,
                style: const pw.TextStyle(fontSize: 10),
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _experience(PortfolioDocumentExperience item) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              item.company,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            ),
            pw.Text(
              item.period,
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
            ),
          ],
        ),
        pw.Text(
          item.title,
          style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic),
        ),
        pw.SizedBox(height: 4),
        pw.Text(item.summary, style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 4),
        ...item.highlights.map(
          (highlight) => pw.Bullet(
            text: highlight,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  pw.Widget _project(
    PortfolioDocumentProject project,
    _ResumeLabels labels, {
    required bool includeDescription,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          project.name,
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
        ),
        pw.Text(project.summary, style: const pw.TextStyle(fontSize: 10)),
        if (includeDescription && project.description.isNotEmpty)
          pw.Text(project.description, style: const pw.TextStyle(fontSize: 9)),
        if (project.tags.isNotEmpty)
          pw.Text(
            '${labels.techStack}: ${project.tags.join(', ')}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _link(PortfolioDocumentLink link) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Text(
            '${link.label}: ',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
          ),
          pw.Text(
            link.url,
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
