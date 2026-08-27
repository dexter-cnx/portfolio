import 'portfolio_models.dart';

final class PortfolioDataWithExportSelection extends PortfolioData {
  PortfolioDataWithExportSelection({
    required super.site,
    required super.hero,
    required super.about,
    required super.experience,
    required super.featuredProjects,
    required super.otherProjects,
    required super.contact,
    required super.socialLinks,
    required super.nav,
    required Set<String> pdfProjectRepositoryUrls,
  }) : pdfProjectRepositoryUrls = Set<String>.unmodifiable(
         pdfProjectRepositoryUrls,
       );

  final Set<String> pdfProjectRepositoryUrls;
}
