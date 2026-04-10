import 'dart:ui';

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
import '../widgets/resume_pdf_generator.dart';
import '../widgets/mouse_glow_background.dart';

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

  // Section keys for anchor navigation
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
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

  Future<void> _launchURL(String url) async {
    if (url.startsWith('#')) {
      final key = _getKeyForId(url.substring(1));
      if (key != null) _scrollToSection(key);
      return;
    }

    // Local PDF assets served relative to index.html on web
    if (url.startsWith('assets/pdf/') &&
        (Uri.base.scheme == 'http' || Uri.base.scheme == 'https')) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return;
    }

    final uri = Uri.parse(url);
    final mode = (uri.scheme == 'http' || uri.scheme == 'https')
        ? LaunchMode.platformDefault
        : LaunchMode.externalApplication;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: mode);
    }
  }

  void _scrollToSection(GlobalKey key) {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  GlobalKey? _getKeyForId(String id) => switch (id) {
        'about' => _aboutKey,
        'experience' => _experienceKey,
        'projects' => _projectsKey,
        'contact' => _contactKey,
        _ => null,
      };

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
          // Transparent so the gradient background shows through the glass nav
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: _GlassNavBar(
            ownerName: data.site.ownerName,
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
          body: MouseGlowBackground(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // Hero has its own top-padding to clear the transparent navbar
                      HeroSectionWidget(
                        key: _heroKey,
                        hero: data.hero,
                        onCtaTap: _launchURL,
                      ),
                      AboutSectionWidget(
                        key: _aboutKey,
                        about: data.about,
                      ),
                      ExperienceSectionWidget(
                        key: _experienceKey,
                        experience: data.experience,
                      ),
                      ProjectsSectionWidget(
                        key: _projectsKey,
                        featured: data.featuredProjects,
                        other: data.otherProjects,
                        onLinkTap: _launchURL,
                      ),
                      ContactSectionWidget(
                        key: _contactKey,
                        contact: data.contact,
                        socialLinks: data.socialLinks,
                        onCtaTap: _launchURL,
                      ),
                    ],
                  ),
                ),

                // Desktop side rails
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
          ),
        );
      },
    );
  }
}

// ── Glassmorphism Navigation Bar ───────────────────────────────────────────────

class _GlassNavBar extends StatefulWidget implements PreferredSizeWidget {
  final String ownerName;
  final List<NavItem> nav;
  final String resumeUrl;
  final Function(String id) onNavTap;
  final VoidCallback onLanguageToggle;
  final VoidCallback onResumeTap;

  const _GlassNavBar({
    required this.ownerName,
    required this.nav,
    required this.resumeUrl,
    required this.onNavTap,
    required this.onLanguageToggle,
    required this.onResumeTap,
  });

  @override
  State<_GlassNavBar> createState() => _GlassNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _GlassNavBarState extends State<_GlassNavBar> {
  bool _menuOpen = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Main bar ──────────────────────────────────────────────────────────
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 72,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 48,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: AppTheme.glassNavOpacity),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withValues(alpha: 0.08),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  // Logo / name
                  InkWell(
                    onTap: () => widget.onNavTap('hero'),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 8),
                      child: Text(
                        widget.ownerName.isNotEmpty
                            ? widget.ownerName
                            : 'Dexter CNX',
                        style:
                            Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: AppTheme.accent,
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 18,
                                ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Desktop nav links
                  if (!isMobile)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...widget.nav.asMap().entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(left: 28),
                            child: _NavLink(
                              number: '0${entry.key + 1}',
                              label: entry.value.label,
                              onTap: () => widget.onNavTap(entry.value.id),
                            ),
                          ),
                        ),
                        const SizedBox(width: 28),
                        _LangToggle(onTap: widget.onLanguageToggle),
                        const SizedBox(width: 16),
                        _ResumeButton(onTap: widget.onResumeTap),
                      ],
                    )
                  else ...[
                    _LangToggle(onTap: widget.onLanguageToggle),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _menuOpen ? Icons.close : Icons.menu,
                          key: ValueKey(_menuOpen),
                          color: AppTheme.accent,
                        ),
                      ),
                      onPressed: () => setState(() => _menuOpen = !_menuOpen),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),

        // ── Mobile dropdown ───────────────────────────────────────────────────
        if (isMobile && _menuOpen)
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(alpha: AppTheme.glassNavOpacity + 0.04),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...widget.nav.asMap().entries.map(
                      (entry) => ListTile(
                        onTap: () {
                          setState(() => _menuOpen = false);
                          widget.onNavTap(entry.value.id);
                        },
                        leading: Text(
                          '0${entry.key + 1}.',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: AppTheme.accent,
                                  ),
                        ),
                        title: Text(
                          entry.value.label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.textPrimary),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: _ResumeButton(onTap: widget.onResumeTap),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// ── Nav sub-widgets ────────────────────────────────────────────────────────────

class _NavLink extends StatefulWidget {
  final String number;
  final String label;
  final VoidCallback onTap;

  const _NavLink({
    required this.number,
    required this.label,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            fontFamily: 'JetBrains Mono',
            fontSize: 13,
            color: _hovered ? AppTheme.accent : AppTheme.textMuted,
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '${widget.number}. ',
                  style: TextStyle(color: AppTheme.accent.withValues(alpha: 0.8)),
                ),
                TextSpan(
                  text: widget.label,
                  style: TextStyle(
                    color: _hovered ? AppTheme.accent : AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangToggle extends StatelessWidget {
  final VoidCallback onTap;

  const _LangToggle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        context.locale.languageCode == 'en' ? 'TH' : 'EN',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.accent,
              fontFamily: 'JetBrains Mono',
            ),
      ),
    );
  }
}

class _ResumeButton extends StatelessWidget {
  final VoidCallback onTap;

  const _ResumeButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      child: Text('btn_resume'.tr()),
    );
  }
}
