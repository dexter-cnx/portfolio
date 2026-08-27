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
    required List<OtherProject> openSourceProjects,
    required List<FeaturedProject> pdfFeaturedProjects,
    required List<OtherProject> pdfOtherProjects,
  }) : openSourceProjects = List<OtherProject>.unmodifiable(openSourceProjects),
       pdfFeaturedProjects = List<FeaturedProject>.unmodifiable(
         pdfFeaturedProjects,
       ),
       pdfOtherProjects = List<OtherProject>.unmodifiable(pdfOtherProjects);

  final List<OtherProject> openSourceProjects;
  final List<FeaturedProject> pdfFeaturedProjects;
  final List<OtherProject> pdfOtherProjects;
}
