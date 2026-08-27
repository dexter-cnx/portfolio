import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio/models/portfolio_models.dart';
import 'package:flutter_web_portfolio_starter/features/portfolio_documents/application/portfolio_document_mapper.dart';

void main() {
  test('maps portfolio presentation data into normalized document data', () {
    final data = PortfolioData(
      site: Site(
        name: 'Portfolio',
        ownerName: 'Dexter',
        role: 'Flutter Developer',
        location: 'Chiang Mai',
        email: 'dexter@example.com',
        resumeUrl: '',
        seo: SiteSeo.empty(),
      ),
      hero: HeroSection.empty(),
      about: About(
        title: 'About',
        paragraphs: const ['Summary'],
        skills: const ['Flutter', 'Rust'],
        profileImage: '',
      ),
      experience: [
        Experience(
          company: 'Example Co',
          title: 'Developer',
          period: '2025–2026',
          url: 'https://example.com',
          summary: 'Built products.',
          highlights: const ['Shipped features'],
          tech: const ['Flutter'],
        ),
      ],
      featuredProjects: [
        FeaturedProject(
          name: 'dxtr_box',
          summary: 'Local data layer',
          longDescription: 'Fast local-first storage.',
          repoUrl: 'https://github.com/dexter-cnx/dxtr_box',
          liveUrl: '',
          images: const [],
          urls: const [],
          tags: const ['Dart', 'Rust'],
        ),
      ],
      otherProjects: [
        OtherProject(
          name: 'analythis',
          summary: 'Repository analysis tool',
          repoUrl: 'https://github.com/dexter-cnx/analythis',
          liveUrl: '',
          images: const [],
          tags: const ['TypeScript'],
        ),
      ],
      contact: Contact(
        title: 'Contact',
        body: '',
        ctaLabel: '',
        ctaUrl: '',
        phone: '000',
      ),
      socialLinks: [
        SocialLink(label: 'GitHub', url: 'https://github.com/dexter-cnx'),
      ],
      nav: const [],
    );

    final generatedAt = DateTime.utc(2026, 8, 27, 8, 0);
    final document = const PortfolioDocumentMapper().map(
      data,
      locale: 'th',
      generatedAt: generatedAt,
    );

    expect(document.locale, 'th');
    expect(document.profile.name, 'Dexter');
    expect(document.profile.phone, '000');
    expect(document.skills, ['Flutter', 'Rust']);
    expect(document.experience.single.company, 'Example Co');
    expect(document.projects, hasLength(2));
    expect(document.projects.first.featured, isTrue);
    expect(document.projects.last.featured, isFalse);
    expect(document.links.single.label, 'GitHub');
    expect(document.generatedAt, generatedAt);
    expect(document.toJson()['locale'], 'th');
  });

  test('normalizes unsupported locale to English', () {
    final data = PortfolioData.empty();

    final document = const PortfolioDocumentMapper().map(
      data,
      locale: 'ja',
      generatedAt: DateTime.utc(2026),
    );

    expect(document.locale, 'en');
  });
}
