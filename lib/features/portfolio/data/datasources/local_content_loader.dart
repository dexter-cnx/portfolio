import 'dart:convert';

import 'package:flutter/services.dart';

import '../../models/portfolio_data_with_export_selection.dart';
import '../../models/portfolio_models.dart';

class LocalContentLoader {
  const LocalContentLoader();

  Future<PortfolioData> loadPortfolioData([String locale = 'en']) async {
    final languageCode = locale == 'th' ? 'th' : 'en';
    final contentResponse = await rootBundle.loadString(
      'assets/content/portfolio_content_$languageCode.json',
    );
    final contentDecoded = jsonDecode(contentResponse);
    if (contentDecoded is! Map<String, dynamic>) {
      throw const FormatException('Portfolio content must be a JSON object.');
    }
    final fallback = PortfolioData.fromJson(contentDecoded);

    final projectsResponse = await rootBundle.loadString(
      'assets/content/open_source_projects_$languageCode.json',
    );
    final projectsDecoded = jsonDecode(projectsResponse);
    if (projectsDecoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Open source project content must be a JSON object.',
      );
    }
    final rawProjects = projectsDecoded['projects'];
    if (rawProjects is! List) {
      throw const FormatException('Open source projects must be a JSON array.');
    }

    final visibleProjects = <OtherProject>[];
    final pdfProjects = <OtherProject>[];
    for (final item in rawProjects) {
      if (item is! Map) continue;
      final json = Map<String, dynamic>.from(item);
      final project = _otherProjectFromGenerated(json);
      if (json['visible'] == true) visibleProjects.add(project);
      if (json['includeInPdf'] == true) pdfProjects.add(project);
    }

    return PortfolioDataWithExportSelection(
      site: fallback.site,
      hero: fallback.hero,
      about: fallback.about,
      experience: fallback.experience,
      featuredProjects: fallback.featuredProjects,
      otherProjects: fallback.otherProjects,
      openSourceProjects: visibleProjects,
      contact: fallback.contact,
      socialLinks: fallback.socialLinks,
      nav: fallback.nav,
      pdfFeaturedProjects: const <FeaturedProject>[],
      pdfOtherProjects: pdfProjects,
    );
  }

  OtherProject _otherProjectFromGenerated(Map<String, dynamic> json) {
    return OtherProject(
      name: json['name'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      repoUrl: json['repoUrl'] as String? ?? '',
      liveUrl: json['liveUrl'] as String? ?? '',
      images: (json['images'] as List? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      tags: (json['tags'] as List? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
    );
  }

  Future<String> loadRawJson([String locale = 'en']) {
    final languageCode = locale == 'th' ? 'th' : 'en';
    return rootBundle.loadString(
      'assets/content/portfolio_content_$languageCode.json',
    );
  }
}
