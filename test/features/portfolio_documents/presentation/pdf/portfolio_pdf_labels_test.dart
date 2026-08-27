import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/presentation/pdf/portfolio_pdf_labels.dart';

void main() {
  const catalog = PortfolioPdfLabelCatalog();

  test('returns English labels by default', () {
    final labels = catalog.forLocale('en');

    expect(labels.forKey('summary'), 'Summary');
    expect(labels.forKey('projects'), 'Projects');
    expect(labels.techStack, 'Tech Stack');
    expect(labels.generated, 'Generated from Portfolio Website');
  });

  test('returns Thai labels for Thai locale', () {
    final labels = catalog.forLocale('th');

    expect(labels.forKey('summary'), 'สรุป');
    expect(labels.forKey('projects'), 'ผลงาน');
    expect(labels.techStack, 'เทคโนโลยีที่ใช้');
    expect(labels.generated, 'สร้างจากเว็บไซต์พอร์ตโฟลิโอ');
  });

  test('falls back to label key for unknown section metadata', () {
    final labels = catalog.forLocale('en');

    expect(labels.forKey('custom_section'), 'custom_section');
  });
}
