import '../../portfolio/models/portfolio_data_with_export_selection.dart';
import '../../portfolio/models/portfolio_models.dart';
import '../domain/entities/portfolio_document_data.dart';

final class PortfolioDocumentMapper {
  const PortfolioDocumentMapper();

  PortfolioDocumentData map(
    PortfolioData data, {
    required String locale,
    DateTime? generatedAt,
  }) {
    final openSourceFeatured = data is PortfolioDataWithExportSelection
        ? data.pdfFeaturedProjects
        : const <FeaturedProject>[];
    final openSourceOther = data is PortfolioDataWithExportSelection
        ? data.pdfOtherProjects
        : data.otherProjects;

    return PortfolioDocumentData(
      locale: locale == 'th' ? 'th' : 'en',
      profile: PortfolioDocumentProfile(
        name: data.site.ownerName,
        role: data.site.role,
        location: data.site.location,
        email: data.site.email,
        phone: data.contact.phone ?? '',
      ),
      summary: List<String>.unmodifiable(data.about.paragraphs),
      skills: List<String>.unmodifiable(data.about.skills),
      experience: data.experience
          .map(
            (item) => PortfolioDocumentExperience(
              company: item.company,
              title: item.title,
              period: item.period,
              summary: item.summary,
              highlights: List<String>.unmodifiable(item.highlights),
              tech: List<String>.unmodifiable(item.tech),
              url: item.url,
            ),
          )
          .toList(growable: false),
      projects: <PortfolioDocumentProject>[
        ...data.featuredProjects.map(
          (item) => PortfolioDocumentProject(
            name: item.name,
            summary: item.summary,
            description: item.longDescription,
            repositoryUrl: item.repoUrl,
            liveUrl: item.liveUrl,
            tags: List<String>.unmodifiable(item.tags),
            links: item.urls
                .map(
                  (link) =>
                      PortfolioDocumentLink(label: link.title, url: link.url),
                )
                .toList(growable: false),
            featured: true,
          ),
        ),
        ...openSourceFeatured.map(
          (item) => PortfolioDocumentProject(
            name: item.name,
            summary: item.summary,
            description: item.longDescription,
            repositoryUrl: item.repoUrl,
            liveUrl: item.liveUrl,
            tags: List<String>.unmodifiable(item.tags),
            links: item.urls
                .map(
                  (link) =>
                      PortfolioDocumentLink(label: link.title, url: link.url),
                )
                .toList(growable: false),
            featured: false,
          ),
        ),
        ...openSourceOther.map(
          (item) => PortfolioDocumentProject(
            name: item.name,
            summary: item.summary,
            description: '',
            repositoryUrl: item.repoUrl,
            liveUrl: item.liveUrl,
            tags: List<String>.unmodifiable(item.tags),
            links: const <PortfolioDocumentLink>[],
            featured: false,
          ),
        ),
      ],
      links: data.socialLinks
          .map(
            (item) => PortfolioDocumentLink(label: item.label, url: item.url),
          )
          .toList(growable: false),
      generatedAt: (generatedAt ?? DateTime.now()).toUtc(),
    );
  }
}
