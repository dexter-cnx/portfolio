import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../models/portfolio_models.dart';

class ResumePdfGenerator {
  static Future<void> generateAndDownload(PortfolioData data, String locale) async {
    final pdf = pw.Document();

    // Determine fonts based on locale
    final bool isThai = locale == 'th';
    
    // Load fonts
    final font = isThai 
        ? await PdfGoogleFonts.notoSansThaiRegular() 
        : await PdfGoogleFonts.interRegular();
    final fontBold = isThai 
        ? await PdfGoogleFonts.notoSansThaiBold() 
        : await PdfGoogleFonts.interBold();
    
    final DateTime now = DateTime.now();
    final String dateStr = "${now.day}/${now.month}/${now.year}";

    // Translations for PDF Labels
    final labels = {
      'en': {
        'summary': 'Summary',
        'experience': 'Experience',
        'skills': 'Technical Skills',
        'projects': 'Featured Projects',
        'tech_stack': 'Tech Stack',
        'generated': 'Generated from Portfolio Website',
        'links': 'Links & Social',
      },
      'th': {
        'summary': 'สรุป',
        'experience': 'ประสบการณ์การทำงาน',
        'skills': 'ทักษะทางเทคนิค',
        'projects': 'ผลงานที่โดดเด่น',
        'tech_stack': 'เทคโนโลยีที่ใช้',
        'generated': 'สร้างจากเว็บไซต์พอร์ตโฟลิโอ',
        'links': 'ลิงก์และโซเชียล',
      }
    };

    final currentLabels = labels[locale] ?? labels['en']!;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (context) => [
          // Header
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    data.site.ownerName,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 24),
                  ),
                  pw.Text(
                    data.site.role,
                    style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700),
                  ),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(data.site.email, style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(data.site.location, style: const pw.TextStyle(fontSize: 10)),
                  if (data.contact.phone != null)
                    pw.Text(data.contact.phone!, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
          pw.Divider(thickness: 1, color: PdfColors.grey300, indent: 0, endIndent: 0),
          pw.SizedBox(height: 10),

          // About/Summary
          _buildSectionTitle(currentLabels['summary']!, fontBold),
          pw.Text(
            data.about.paragraphs.join('\n\n'),
            style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.4),
          ),
          pw.SizedBox(height: 20),

          // Experience
          _buildSectionTitle(currentLabels['experience']!, fontBold),
          ...data.experience.map((exp) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(exp.company, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                      pw.Text(exp.period,
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ],
                  ),
                  pw.Text(exp.title,
                      style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
                  pw.SizedBox(height: 4),
                  pw.Text(exp.summary, style: const pw.TextStyle(fontSize: 10)),
                  pw.SizedBox(height: 4),
                  ...exp.highlights.map((h) => pw.Bullet(
                    text: h,
                    style: const pw.TextStyle(fontSize: 10),
                  )),
                  pw.SizedBox(height: 10),
                ],
              )),

          // Skills
          _buildSectionTitle(currentLabels['skills']!, fontBold),
          pw.Wrap(
            spacing: 5,
            runSpacing: 5,
            children: data.about.skills
                .map((skill) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.grey200,
                        borderRadius: pw.BorderRadius.all(pw.Radius.circular(4)),
                      ),
                      child: pw.Text(skill, style: const pw.TextStyle(fontSize: 9)),
                    ))
                .toList(),
          ),
          pw.SizedBox(height: 20),

          // Projects
          _buildSectionTitle(currentLabels['projects']!, fontBold),
          ...data.featuredProjects.map((proj) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(proj.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.Text(proj.summary, style: const pw.TextStyle(fontSize: 10)),
                  pw.Text('${currentLabels["tech_stack"]}: ${proj.tags.join(", ")}',
                      style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                  pw.SizedBox(height: 8),
                ],
              )),
          
          pw.SizedBox(height: 20),

          // Social Links
          _buildSectionTitle(currentLabels['links']!, fontBold),
          ...data.socialLinks.map((link) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 4),
                child: pw.Row(
                  children: [
                    pw.Text('${link.label}: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                    pw.Text(link.url, style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue700)),
                  ],
                ),
              )),

          pw.Spacer(),
          pw.Divider(thickness: 0.5, color: PdfColors.grey300),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(currentLabels['generated']!,
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
              pw.Text('Date: $dateStr',
                  style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
            ],
          ),
        ],
      ),
    );

    // Save/Download
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${data.site.ownerName}_Resume.pdf',
    );
  }

  static pw.Widget _buildSectionTitle(String title, pw.Font fontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13, color: PdfColors.blueGrey700),
        ),
        pw.SizedBox(height: 4),
        pw.Container(
          height: 1.5,
          width: 40,
          color: PdfColors.blueGrey700,
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }
}
