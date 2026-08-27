final class RepositoryPortfolioStatus {
  const RepositoryPortfolioStatus({
    required this.schemaVersion,
    required this.title,
    required this.tagline,
    required this.status,
    required this.version,
    required this.shortSummary,
    required this.longSummary,
    required this.highlights,
    required this.tech,
    required this.links,
    required this.updatedAt,
  });

  final int schemaVersion;
  final String title;
  final String tagline;
  final String status;
  final String version;
  final String shortSummary;
  final String longSummary;
  final List<String> highlights;
  final List<String> tech;
  final RepositoryPortfolioLinks links;
  final DateTime? updatedAt;

  factory RepositoryPortfolioStatus.fromJson(Map<String, Object?> json) {
    final project = Map<String, Object?>.from(json['project'] as Map? ?? const {});
    final summary = Map<String, Object?>.from(json['summary'] as Map? ?? const {});
    final links = Map<String, Object?>.from(json['links'] as Map? ?? const {});

    return RepositoryPortfolioStatus(
      schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
      title: project['title'] as String? ?? '',
      tagline: project['tagline'] as String? ?? '',
      status: project['status'] as String? ?? '',
      version: project['version'] as String? ?? '',
      shortSummary: summary['short'] as String? ?? '',
      longSummary: summary['long'] as String? ?? '',
      highlights: _stringList(json['highlights']),
      tech: _stringList(json['tech']),
      links: RepositoryPortfolioLinks.fromJson(links),
      updatedAt: switch (json['updatedAt']) {
        final String value when value.isNotEmpty => DateTime.tryParse(value)?.toUtc(),
        _ => null,
      },
    );
  }

  static List<String> _stringList(Object? value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList(growable: false);
  }
}

final class RepositoryPortfolioLinks {
  const RepositoryPortfolioLinks({
    required this.repository,
    required this.homepage,
    required this.package,
    required this.docs,
    required this.demo,
  });

  final String repository;
  final String homepage;
  final String package;
  final String docs;
  final String demo;

  factory RepositoryPortfolioLinks.fromJson(Map<String, Object?> json) {
    String read(String key) => json[key] as String? ?? '';

    return RepositoryPortfolioLinks(
      repository: read('repository'),
      homepage: read('homepage'),
      package: read('package'),
      docs: read('docs'),
      demo: read('demo'),
    );
  }
}
