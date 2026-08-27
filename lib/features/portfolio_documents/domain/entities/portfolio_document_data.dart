final class PortfolioDocumentData {
  const PortfolioDocumentData({
    required this.locale,
    required this.profile,
    required this.summary,
    required this.skills,
    required this.experience,
    required this.projects,
    required this.links,
    required this.generatedAt,
  });

  final String locale;
  final PortfolioDocumentProfile profile;
  final List<String> summary;
  final List<String> skills;
  final List<PortfolioDocumentExperience> experience;
  final List<PortfolioDocumentProject> projects;
  final List<PortfolioDocumentLink> links;
  final DateTime generatedAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'locale': locale,
    'profile': profile.toJson(),
    'summary': summary,
    'skills': skills,
    'experience': experience.map((item) => item.toJson()).toList(),
    'projects': projects.map((item) => item.toJson()).toList(),
    'links': links.map((item) => item.toJson()).toList(),
    'generatedAt': generatedAt.toUtc().toIso8601String(),
  };
}

final class PortfolioDocumentProfile {
  const PortfolioDocumentProfile({
    required this.name,
    required this.role,
    required this.location,
    required this.email,
    required this.phone,
  });

  final String name;
  final String role;
  final String location;
  final String email;
  final String phone;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'role': role,
    'location': location,
    'email': email,
    'phone': phone,
  };
}

final class PortfolioDocumentExperience {
  const PortfolioDocumentExperience({
    required this.company,
    required this.title,
    required this.period,
    required this.summary,
    required this.highlights,
    required this.tech,
    required this.url,
  });

  final String company;
  final String title;
  final String period;
  final String summary;
  final List<String> highlights;
  final List<String> tech;
  final String url;

  Map<String, Object?> toJson() => <String, Object?>{
    'company': company,
    'title': title,
    'period': period,
    'summary': summary,
    'highlights': highlights,
    'tech': tech,
    'url': url,
  };
}

final class PortfolioDocumentProject {
  const PortfolioDocumentProject({
    required this.name,
    required this.summary,
    required this.description,
    required this.repositoryUrl,
    required this.liveUrl,
    required this.tags,
    required this.links,
    required this.featured,
  });

  final String name;
  final String summary;
  final String description;
  final String repositoryUrl;
  final String liveUrl;
  final List<String> tags;
  final List<PortfolioDocumentLink> links;
  final bool featured;

  Map<String, Object?> toJson() => <String, Object?>{
    'name': name,
    'summary': summary,
    'description': description,
    'repositoryUrl': repositoryUrl,
    'liveUrl': liveUrl,
    'tags': tags,
    'links': links.map((item) => item.toJson()).toList(),
    'featured': featured,
  };
}

final class PortfolioDocumentLink {
  const PortfolioDocumentLink({required this.label, required this.url});

  final String label;
  final String url;

  Map<String, Object?> toJson() => <String, Object?>{
    'label': label,
    'url': url,
  };
}
