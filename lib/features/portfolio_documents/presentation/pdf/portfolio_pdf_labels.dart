final class PortfolioPdfLabels {
  const PortfolioPdfLabels({
    required this.summary,
    required this.experience,
    required this.skills,
    required this.projects,
    required this.techStack,
    required this.generated,
    required this.links,
  });

  final String summary;
  final String experience;
  final String skills;
  final String projects;
  final String techStack;
  final String generated;
  final String links;

  String forKey(String key) {
    return switch (key) {
      'summary' => summary,
      'experience' => experience,
      'skills' => skills,
      'projects' => projects,
      'links' => links,
      _ => key,
    };
  }
}

final class PortfolioPdfLabelCatalog {
  const PortfolioPdfLabelCatalog();

  PortfolioPdfLabels forLocale(String locale) {
    if (locale == 'th') {
      return const PortfolioPdfLabels(
        summary: 'สรุป',
        experience: 'ประสบการณ์การทำงาน',
        skills: 'ทักษะทางเทคนิค',
        projects: 'ผลงาน',
        techStack: 'เทคโนโลยีที่ใช้',
        generated: 'สร้างจากเว็บไซต์พอร์ตโฟลิโอ',
        links: 'ลิงก์และโซเชียล',
      );
    }

    return const PortfolioPdfLabels(
      summary: 'Summary',
      experience: 'Experience',
      skills: 'Technical Skills',
      projects: 'Projects',
      techStack: 'Tech Stack',
      generated: 'Generated from Portfolio Website',
      links: 'Links & Social',
    );
  }
}
