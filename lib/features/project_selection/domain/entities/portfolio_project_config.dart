final class PortfolioProjectConfig {
  const PortfolioProjectConfig({
    required this.repositoryId,
    this.visible = false,
    this.featured = false,
    this.includeInPdf = false,
    this.sortOrder = 0,
    this.titleOverride = '',
    this.summaryOverride = '',
  });

  final int repositoryId;
  final bool visible;
  final bool featured;
  final bool includeInPdf;
  final int sortOrder;
  final String titleOverride;
  final String summaryOverride;

  PortfolioProjectConfig copyWith({
    bool? visible,
    bool? featured,
    bool? includeInPdf,
    int? sortOrder,
    String? titleOverride,
    String? summaryOverride,
  }) {
    return PortfolioProjectConfig(
      repositoryId: repositoryId,
      visible: visible ?? this.visible,
      featured: featured ?? this.featured,
      includeInPdf: includeInPdf ?? this.includeInPdf,
      sortOrder: sortOrder ?? this.sortOrder,
      titleOverride: titleOverride ?? this.titleOverride,
      summaryOverride: summaryOverride ?? this.summaryOverride,
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'repositoryId': repositoryId,
    'visible': visible,
    'featured': featured,
    'includeInPdf': includeInPdf,
    'sortOrder': sortOrder,
    'titleOverride': titleOverride,
    'summaryOverride': summaryOverride,
  };

  factory PortfolioProjectConfig.fromJson(Map<String, Object?> json) {
    final repositoryId = json['repositoryId'];
    if (repositoryId is! num) {
      throw const FormatException('repositoryId must be a number.');
    }
    return PortfolioProjectConfig(
      repositoryId: repositoryId.toInt(),
      visible: json['visible'] as bool? ?? false,
      featured: json['featured'] as bool? ?? false,
      includeInPdf: json['includeInPdf'] as bool? ?? false,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      titleOverride: json['titleOverride'] as String? ?? '',
      summaryOverride: json['summaryOverride'] as String? ?? '',
    );
  }
}

final class ProjectSelectionConfig {
  const ProjectSelectionConfig({
    this.projects = const <PortfolioProjectConfig>[],
    this.updatedAt,
  });

  final List<PortfolioProjectConfig> projects;
  final DateTime? updatedAt;

  PortfolioProjectConfig forRepository(int repositoryId) {
    for (final project in projects) {
      if (project.repositoryId == repositoryId) return project;
    }
    return PortfolioProjectConfig(repositoryId: repositoryId);
  }

  ProjectSelectionConfig replace(PortfolioProjectConfig project) {
    final next = <PortfolioProjectConfig>[
      for (final current in projects)
        if (current.repositoryId != project.repositoryId) current,
      project,
    ];
    return ProjectSelectionConfig(projects: next, updatedAt: updatedAt);
  }

  ProjectSelectionConfig markUpdated(DateTime value) {
    return ProjectSelectionConfig(projects: projects, updatedAt: value);
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'updatedAt': updatedAt?.toUtc().toIso8601String(),
    'projects': projects.map((project) => project.toJson()).toList(),
  };

  factory ProjectSelectionConfig.fromJson(Map<String, Object?> json) {
    final rawProjects = json['projects'];
    if (rawProjects is! List) {
      throw const FormatException('projects must be a JSON array.');
    }

    final updatedAtValue = json['updatedAt'];
    return ProjectSelectionConfig(
      projects: rawProjects
          .map((item) {
            if (item is! Map) {
              throw const FormatException(
                'Each project config must be an object.',
              );
            }
            return PortfolioProjectConfig.fromJson(
              Map<String, Object?>.from(item),
            );
          })
          .toList(growable: false),
      updatedAt: updatedAtValue is String && updatedAtValue.isNotEmpty
          ? DateTime.tryParse(updatedAtValue)?.toUtc()
          : null,
    );
  }
}
