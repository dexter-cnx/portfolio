import '../../domain/entities/github_project.dart';

final class GitHubProjectModel {
  const GitHubProjectModel({
    required this.id,
    required this.ownerLogin,
    required this.name,
    required this.fullName,
    required this.description,
    required this.htmlUrl,
    required this.homepageUrl,
    required this.language,
    required this.topics,
    required this.stars,
    required this.forks,
    required this.archived,
    required this.isFork,
    required this.createdAt,
    required this.updatedAt,
    required this.pushedAt,
    required this.licenseSpdxId,
  });

  factory GitHubProjectModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'];
    final license = json['license'];

    return GitHubProjectModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      ownerLogin: owner is Map<String, dynamic>
          ? owner['login'] as String? ?? ''
          : '',
      name: json['name'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      htmlUrl: json['html_url'] as String? ?? '',
      homepageUrl: json['homepage'] as String? ?? '',
      language: json['language'] as String? ?? '',
      topics: (json['topics'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      stars: (json['stargazers_count'] as num?)?.toInt() ?? 0,
      forks: (json['forks_count'] as num?)?.toInt() ?? 0,
      archived: json['archived'] as bool? ?? false,
      isFork: json['fork'] as bool? ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
      pushedAt: _parseDate(json['pushed_at']),
      licenseSpdxId: license is Map<String, dynamic>
          ? license['spdx_id'] as String?
          : null,
    );
  }

  final int id;
  final String ownerLogin;
  final String name;
  final String fullName;
  final String description;
  final String htmlUrl;
  final String homepageUrl;
  final String language;
  final List<String> topics;
  final int stars;
  final int forks;
  final bool archived;
  final bool isFork;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? pushedAt;
  final String? licenseSpdxId;

  GitHubProject toEntity() {
    return GitHubProject(
      id: id,
      ownerLogin: ownerLogin,
      name: name,
      fullName: fullName,
      description: description,
      htmlUrl: htmlUrl,
      homepageUrl: homepageUrl,
      language: language,
      topics: List<String>.unmodifiable(topics),
      stars: stars,
      forks: forks,
      archived: archived,
      isFork: isFork,
      createdAt: createdAt,
      updatedAt: updatedAt,
      pushedAt: pushedAt,
      licenseSpdxId: licenseSpdxId,
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value is! String || value.isEmpty) return null;
    return DateTime.tryParse(value)?.toUtc();
  }
}
