import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final class PortfolioPdfComponents {
  const PortfolioPdfComponents();

  pw.Widget sectionTitle(String title) {
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

  pw.Widget externalLink({
    required String label,
    required String url,
  }) {
    final text = label.isEmpty ? url : '$label: $url';
    if (url.isEmpty) {
      return pw.Text(text, style: const pw.TextStyle(fontSize: 10));
    }

    return pw.UrlLink(
      destination: url,
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue700),
      ),
    );
  }

  pw.Widget footer({
    required pw.Context context,
    required String generatedLabel,
    required String dateText,
  }) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 0.5, color: PdfColors.grey300),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              generatedLabel,
              style: const pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey500,
              ),
            ),
            pw.Text(
              [
                if (dateText.isNotEmpty) dateText,
                '${context.pageNumber}/${context.pagesCount}',
              ].join(' · '),
              style: const pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
