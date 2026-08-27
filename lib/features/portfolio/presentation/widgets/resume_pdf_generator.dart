import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../portfolio_documents/application/portfolio_document_mapper.dart';
import '../../../portfolio_documents/domain/entities/portfolio_document_data.dart';
import '../../models/portfolio_models.dart';

class ResumePdfGenerator {
  static Future<void> generateAndDownload(
    PortfolioData data,
    String locale,
  ) async {
    final documentData = const PortfolioDocumentMapper().map(
      data,
      locale: locale,
    );
    await generateDocument(documentData);
  }

  static Future<void> generateDocument(PortfolioDocumentData data) async {
    final pdf = pw.Document();
    final isThai = data.locale == 'th';
    final font = isThai
        ? await PdfGoogleFonts.notoSansThaiRegular()
        : await PdfGoogleFonts.interRegular();
    final fontBold = isThai
        ? await PdfGoogleFonts.notoSansThaiBold()
        : await PdfGoogleFonts.interBold();

    final generatedAt = data.generatedAt.toLocal();
    final dateStr =
        '${generatedAt.day}/${generatedAt.month}/${generatedAt.year}';
    final labels = _labelsFor(data.locale);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (context) => <pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    data.profile.name,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  pw.Text(
                    data.profile.role,
                    style: const pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.grey700,
                    ),
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
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey300),
          pw.SizedBox(height: 10),
          _buildSectionTitle(labels.summary),
          pw.Text(
            data.summary.join('\n\n'),
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
          ),
          pw.SizedBox(height: 20),
          _buildSectionTitle(labels.experience),
          ...data.experience.map(
            (item) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      item.company,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    pw.Text(
                      item.period,
                      style: const pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  item.title,
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontStyle: pw.FontStyle.italic,
                  ),
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
            ),
          ),
          _buildSectionTitle(labels.skills),
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
          _buildSectionTitle(labels.projects),
          ...data.projects
              .where((project) => project.featured)
              .map(
                (project) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      project.name,
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                    pw.Text(
                      project.summary,
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                    pw.Text(
                      '${labels.techStack}: ${project.tags.join(', ')}',
                      style: const pw.TextStyle(
                        fontSize: 9,
                        color: PdfColors.grey700,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                  ],
                ),
              ),
          pw.SizedBox(height: 20),
          _buildSectionTitle(labels.links),
          ...data.links.map(
            (link) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                children: [
                  pw.Text(
                    '${link.label}: ',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                  pw.Text(
                    link.url,
                    style: const pw.TextStyle(
                      fontSize: 10,
                      color: PdfColors.blue700,
                    ),
                  ),
                ],
              ),
            ),
          ),
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

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
      name: '${data.profile.name}_Resume.pdf',
    );
  }

  static _ResumeLabels _labelsFor(String locale) {
    if (locale == 'th') {
      return const _ResumeLabels(
        summary: 'สรุป',
        experience: 'ประสบการณ์การทำงาน',
        skills: 'ทักษะทางเทคนิค',
        projects: 'ผลงานที่โดดเด่น',
        techStack: 'เทคโนโลยีที่ใช้',
        generated: 'สร้างจากเว็บไซต์พอร์ตโฟลิโอ',
        links: 'ลิงก์และโซเชียล',
      );
    }
    return const _ResumeLabels(
      summary: 'Summary',
      experience: 'Experience',
      skills: 'Technical Skills',
      projects: 'Featured Projects',
      techStack: 'Tech Stack',
      generated: 'Generated from Portfolio Website',
      links: 'Links & Social',
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
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
