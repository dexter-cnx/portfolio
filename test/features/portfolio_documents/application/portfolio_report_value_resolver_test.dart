import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_report_value_resolver.dart';

void main() {
  const resolver = PortfolioReportValueResolver();
  final data = <String, dynamic>{
    'profile': <String, dynamic>{'name': 'Dexter'},
    'skills': <String>['Flutter', 'Rust'],
    'projects': <Map<String, dynamic>>[
      <String, dynamic>{'name': 'Portfolio'},
    ],
  };

  test('resolves dotted map paths', () {
    expect(resolver.resolve('profile.name', data), 'Dexter');
  });

  test('resolves numeric list indexes', () {
    expect(resolver.resolve('skills.1', data), 'Rust');
    expect(resolver.resolve('projects.0.name', data), 'Portfolio');
  });

  test('accepts wrapped placeholders', () {
    expect(resolver.resolve('{{ profile.name }}', data), 'Dexter');
  });

  test('returns empty string for missing paths', () {
    expect(resolver.resolve('profile.email', data), '');
    expect(resolver.resolve('skills.9', data), '');
  });

  test('returns empty string for null or empty expressions', () {
    expect(resolver.resolve(null, data), '');
    expect(resolver.resolve('   ', data), '');
  });
}
