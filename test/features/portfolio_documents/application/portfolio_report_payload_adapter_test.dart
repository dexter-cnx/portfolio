import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_payload_adapter.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/domain/entities/portfolio_document_data.dart';

void main() {
  test('adapts normalized document data to report-engine-friendly payload', () {
    final data = PortfolioDocumentData(
      locale: 'en',
      profile: const PortfolioDocumentProfile(
        name: 'Dexter',
        role: 'Flutter Developer',
        location: 'Chiang Mai',
        email: 'dexter@example.com',
        phone: '',
      ),
      summary: const ['Summary'],
      skills: const ['Flutter', 'Rust'],
      experience: const [],
      projects: const [
        PortfolioDocumentProject(
          name: 'dxtr_box',
          summary: 'Local data layer',
          description: 'Fast local-first storage.',
          repositoryUrl: 'https://github.com/dexter-cnx/dxtr_box',
          liveUrl: '',
          tags: ['Dart', 'Rust'],
          links: [],
          featured: true,
        ),
      ],
      links: const [],
      generatedAt: DateTime.utc(2026, 8, 27),
    );

    final payload = const PortfolioReportPayloadAdapter().adapt(data);

    expect((payload['profile'] as Map<String, dynamic>)['name'], 'Dexter');
    expect((payload['skills'] as List<dynamic>)[1], 'Rust');
    expect(
      ((payload['projects'] as List<dynamic>)[0] as Map<String, dynamic>)['name'],
      'dxtr_box',
    );
    expect(payload['generatedAt'], '2026-08-27T00:00:00.000Z');
  });
}
