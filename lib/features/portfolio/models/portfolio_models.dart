class PortfolioData {
  final Site site;
  final HeroSection hero;
  final About about;
  final List<Experience> experience;
  final List<FeaturedProject> featuredProjects;
  final List<OtherProject> otherProjects;
  final Contact contact;
  final List<SocialLink> socialLinks;
  final List<NavItem> nav;

  PortfolioData({
    required this.site,
    required this.hero,
    required this.about,
    required this.experience,
    required this.featuredProjects,
    required this.otherProjects,
    required this.contact,
    required this.socialLinks,
    required this.nav,
  });

  factory PortfolioData.empty() {
    return PortfolioData(
      site: Site.empty(),
      hero: HeroSection.empty(),
      about: About.empty(),
      experience: [],
      featuredProjects: [],
      otherProjects: [],
      contact: Contact.empty(),
      socialLinks: [],
      nav: [],
    );
  }

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      site: Site.fromJson(json['site']),
      hero: HeroSection.fromJson(json['hero']),
      about: About.fromJson(json['about']),
      experience: (json['experience'] as List).map((e) => Experience.fromJson(e)).toList(),
      featuredProjects:
          (json['featuredProjects'] as List).map((e) => FeaturedProject.fromJson(e)).toList(),
      otherProjects: (json['otherProjects'] as List).map((e) => OtherProject.fromJson(e)).toList(),
      contact: Contact.fromJson(json['contact']),
      socialLinks: (json['socialLinks'] as List).map((e) => SocialLink.fromJson(e)).toList(),
      nav: (json['nav'] as List).map((e) => NavItem.fromJson(e)).toList(),
    );
  }
}

class Site {
  final String name;
  final String ownerName;
  final String role;
  final String location;
  final String email;
  final String resumeUrl;
  final SiteSeo seo;

  Site({
    required this.name,
    required this.ownerName,
    required this.role,
    required this.location,
    required this.email,
    required this.resumeUrl,
    required this.seo,
  });

  factory Site.empty() {
    return Site(
      name: '',
      ownerName: '',
      role: '',
      location: '',
      email: '',
      resumeUrl: '',
      seo: SiteSeo.empty(),
    );
  }

  factory Site.fromJson(Map<String, dynamic> json) {
    return Site(
      name: json['name'],
      ownerName: json['ownerName'],
      role: json['role'],
      location: json['location'],
      email: json['email'],
      resumeUrl: json['resumeUrl'],
      seo: SiteSeo.fromJson(json['seo']),
    );
  }
}

class SiteSeo {
  final String title;
  final String description;
  final List<String> keywords;

  SiteSeo({
    required this.title,
    required this.description,
    required this.keywords,
  });

  factory SiteSeo.empty() {
    return SiteSeo(
      title: '',
      description: '',
      keywords: [],
    );
  }

  factory SiteSeo.fromJson(Map<String, dynamic> json) {
    return SiteSeo(
      title: json['title'],
      description: json['description'],
      keywords: List<String>.from(json['keywords']),
    );
  }
}

class HeroSection {
  final String eyebrow;
  final String headline;
  final String subheadline;
  final String description;
  final Cta primaryCta;
  final Cta secondaryCta;

  HeroSection({
    required this.eyebrow,
    required this.headline,
    required this.subheadline,
    required this.description,
    required this.primaryCta,
    required this.secondaryCta,
  });

  factory HeroSection.empty() {
    return HeroSection(
      eyebrow: '',
      headline: '',
      subheadline: '',
      description: '',
      primaryCta: Cta.empty(),
      secondaryCta: Cta.empty(),
    );
  }

  factory HeroSection.fromJson(Map<String, dynamic> json) {
    return HeroSection(
      eyebrow: json['eyebrow'],
      headline: json['headline'],
      subheadline: json['subheadline'],
      description: json['description'],
      primaryCta: Cta.fromJson(json['primaryCta']),
      secondaryCta: Cta.fromJson(json['secondaryCta']),
    );
  }
}

class Cta {
  final String label;
  final String url;

  Cta({required this.label, required this.url});

  factory Cta.empty() {
    return Cta(label: '', url: '');
  }

  factory Cta.fromJson(Map<String, dynamic> json) {
    return Cta(label: json['label'], url: json['url']);
  }
}

class About {
  final String title;
  final List<String> paragraphs;
  final List<String> skills;
  final String profileImage;

  About({
    required this.title,
    required this.paragraphs,
    required this.skills,
    required this.profileImage,
  });

  factory About.empty() {
    return About(
      title: '',
      paragraphs: [],
      skills: [],
      profileImage: '',
    );
  }

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      title: json['title'],
      paragraphs: List<String>.from(json['paragraphs']),
      skills: List<String>.from(json['skills']),
      profileImage: json['profileImage'],
    );
  }
}

class Experience {
  final String company;
  final String title;
  final String period;
  final String url;
  final String summary;
  final List<String> highlights;
  final List<String> tech;

  Experience({
    required this.company,
    required this.title,
    required this.period,
    required this.url,
    required this.summary,
    required this.highlights,
    required this.tech,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      company: json['company'],
      title: json['title'],
      period: json['period'],
      url: json['url'],
      summary: json['summary'],
      highlights: List<String>.from(json['highlights']),
      tech: List<String>.from(json['tech']),
    );
  }
}

class ProjectUrl {
  final String image;
  final String title;
  final String url;

  ProjectUrl({required this.image, required this.title, required this.url});

  factory ProjectUrl.fromJson(Map<String, dynamic> json) {
    return ProjectUrl(
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class FeaturedProject {
  final String name;
  final String summary;
  final String longDescription;
  final String repoUrl;
  final String liveUrl;
  final List<String> images;
  final List<ProjectUrl> urls;
  final List<String> tags;

  FeaturedProject({
    required this.name,
    required this.summary,
    required this.longDescription,
    required this.repoUrl,
    required this.liveUrl,
    required this.images,
    required this.urls,
    required this.tags,
  });

  factory FeaturedProject.fromJson(Map<String, dynamic> json) {
    return FeaturedProject(
      name: json['name'],
      summary: json['summary'],
      longDescription: json['longDescription'] ?? '',
      repoUrl: json['repoUrl'] ?? '',
      liveUrl: json['liveUrl'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : (json['image'] != null ? [json['image']] : []),
      urls: json['urls'] != null 
          ? (json['urls'] as List).map((e) => ProjectUrl.fromJson(e)).toList()
          : [],
      tags: List<String>.from(json['tags']),
    );
  }
}

class OtherProject {
  final String name;
  final String summary;
  final String repoUrl;
  final String liveUrl;
  final List<String> images;
  final List<String> tags;

  OtherProject({
    required this.name,
    required this.summary,
    required this.repoUrl,
    required this.liveUrl,
    required this.images,
    required this.tags,
  });

  factory OtherProject.fromJson(Map<String, dynamic> json) {
    return OtherProject(
      name: json['name'],
      summary: json['summary'],
      repoUrl: json['repoUrl'] ?? '',
      liveUrl: json['liveUrl'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : (json['image'] != null ? [json['image']] : []),
      tags: List<String>.from(json['tags']),
    );
  }
}

class Contact {
  final String title;
  final String body;
  final String ctaLabel;
  final String ctaUrl;
  final String? phone;
  final String? lineId;

  Contact({
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.ctaUrl,
    this.phone,
    this.lineId,
  });

  factory Contact.empty() {
    return Contact(
      title: '',
      body: '',
      ctaLabel: '',
      ctaUrl: '',
    );
  }

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      title: json['title'],
      body: json['body'],
      ctaLabel: json['ctaLabel'],
      ctaUrl: json['ctaUrl'],
      phone: json['phone'],
      lineId: json['lineId'],
    );
  }
}

class SocialLink {
  final String label;
  final String url;

  SocialLink({required this.label, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(label: json['label'], url: json['url']);
  }
}

class NavItem {
  final String id;
  final String label;

  NavItem({required this.id, required this.label});

  factory NavItem.fromJson(Map<String, dynamic> json) {
    return NavItem(id: json['id'], label: json['label']);
  }
}
