final class GitHubProject {
  const GitHubProject({
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
}
