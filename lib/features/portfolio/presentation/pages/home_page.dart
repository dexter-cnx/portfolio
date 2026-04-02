import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/theme/app_theme.dart';
import '../../data/datasources/local_content_loader.dart';
import '../../models/portfolio_models.dart';
import '../widgets/about_section_widget.dart';
import '../widgets/contact_section_widget.dart';
import '../widgets/experience_section_widget.dart';
import '../widgets/projects_section_widget.dart';
import '../widgets/hero_section_widget.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/side_rails.dart';
import '../widgets/fade_in_slide.dart';
import '../widgets/resume_pdf_generator.dart';

class PortfolioHomePage extends StatefulWidget {
  final Function(String) onLocaleChanged;

  const PortfolioHomePage({super.key, required this.onLocaleChanged});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _loader = LocalContentLoader();
  late Future<PortfolioData> _contentFuture;
  final _scrollController = ScrollController();
  String? _lastLocale;

  // Keys for scroll navigation
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Pre-initialize to avoid errors during build initialization
    _contentFuture = Future.value(PortfolioData.empty());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocale = context.locale.languageCode;
    if (_lastLocale != currentLocale) {
      _lastLocale = currentLocale;
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      _contentFuture = _loader.loadPortfolioData(context.locale.languageCode);
    });
  }

  void _toggleLanguage() {
    final newLocale = context.locale.languageCode == 'en' ? 'th' : 'en';
    widget.onLocaleChanged(newLocale);
  }

  void _launchURL(String url) async {
    if (url.startsWith('#')) {
      final key = _getKeyForId(url.substring(1));
      if (key != null) _scrollToSection(key);
      return;
    }

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  GlobalKey? _getKeyForId(String id) {
    switch (id) {
      case 'about':
        return _aboutKey;
      case 'experience':
        return _experienceKey;
      case 'projects':
        return _projectsKey;
      case 'contact':
        return _contactKey;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioData>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.nav.isEmpty) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppTheme.accent),
            ),
          );
        }

        final data = snapshot.data!;

        return Scaffold(
          appBar: _PortfolioNavBar(
            nav: data.nav,
            resumeUrl: data.site.resumeUrl,
            onNavTap: (id) {
              final key = _getKeyForId(id);
              if (key != null) _scrollToSection(key);
            },
            onLanguageToggle: _toggleLanguage,
            onResumeTap: () {
              if (data.site.resumeUrl.isEmpty) {
                ResumePdfGenerator.generateAndDownload(
                  data,
                  context.locale.languageCode,
                );
              } else {
                _launchURL(data.site.resumeUrl);
              }
            },
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    FadeInSlide(
                      delay: const Duration(milliseconds: 100),
                      child: HeroSectionWidget(
                        key: _heroKey,
                        hero: data.hero,
                        onCtaTap: _launchURL,
                      ),
                    ),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 300),
                      child: AboutSectionWidget(
                        key: _aboutKey,
                        about: data.about,
                      ),
                    ),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 500),
                      child: ExperienceSectionWidget(
                        key: _experienceKey,
                        experience: data.experience,
                      ),
                    ),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 700),
                      child: ProjectsSectionWidget(
                        key: _projectsKey,
                        featured: data.featuredProjects,
                        other: data.otherProjects,
                        onLinkTap: _launchURL,
                      ),
                    ),
                    FadeInSlide(
                      delay: const Duration(milliseconds: 900),
                      child: ContactSectionWidget(
                        key: _contactKey,
                        contact: data.contact,
                        socialLinks: data.socialLinks,
                        onCtaTap: _launchURL,
                      ),
                    ),
                  ],
                ),
              ),
              if (ResponsiveLayout.isDesktop(context))
                Positioned(
                  left: 40,
                  bottom: 0,
                  child: SocialRail(
                    socials: data.socialLinks,
                    onLinkTap: _launchURL,
                  ),
                ),
              if (ResponsiveLayout.isDesktop(context))
                Positioned(
                  right: 40,
                  bottom: 0,
                  child: EmailRail(
                    email: data.site.email,
                    onEmailTap: _launchURL,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _PortfolioNavBar extends StatelessWidget implements PreferredSizeWidget {
  final List<NavItem> nav;
  final String resumeUrl;
  final Function(String id) onNavTap;
  final VoidCallback onLanguageToggle;
  final VoidCallback onResumeTap;

  const _PortfolioNavBar({
    required this.nav,
    required this.resumeUrl,
    required this.onNavTap,
    required this.onLanguageToggle,
    required this.onResumeTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 48,
        vertical: 8,
      ),
      color: AppTheme.background.withValues(alpha: 0.9),
      child: Row(
        children: [
          InkWell(
            onTap: () => onNavTap('hero'),
            child: Text(
              'Kitiponf Sarajan',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.accent,
                fontFamily: 'JetBrains Mono',
              ),
            ),
          ),
          const Spacer(),
          if (!isMobile)
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...nav.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(left: 32),
                        child: TextButton(
                          onPressed: () => onNavTap(item.id),
                          child: Row(
                            children: [
                              Text(
                                '0${nav.indexOf(item) + 1}. ',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: AppTheme.accent),
                              ),
                              Text(
                                item.label,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: AppTheme.textPrimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 32),
                    TextButton(
                      onPressed: onLanguageToggle,
                      child: Text(
                        context.locale.languageCode == 'en' ? 'TH' : 'EN',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppTheme.accent,
                              fontFamily: 'JetBrains Mono',
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: onResumeTap,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Text('btn_resume'.tr()),
                    ),
                  ],
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.menu, color: AppTheme.accent),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
