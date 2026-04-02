import 'package:flutter/material.dart';
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

class PortfolioHomePage extends StatefulWidget {
  const PortfolioHomePage({super.key});

  @override
  State<PortfolioHomePage> createState() => _PortfolioHomePageState();
}

class _PortfolioHomePageState extends State<PortfolioHomePage> {
  final _loader = LocalContentLoader();
  late final Future<PortfolioData> _contentFuture;

  @override
  void initState() {
    super.initState();
    _contentFuture = _loader.loadPortfolioData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioData>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppTheme.accent)),
          );
        }

        final data = snapshot.data!;

        return Scaffold(
          appBar: _PortfolioNavBar(nav: data.nav),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    HeroSectionWidget(hero: data.hero),
                    AboutSectionWidget(about: data.about),
                    ExperienceSectionWidget(experience: data.experience),
                    ProjectsSectionWidget(
                      featured: data.featuredProjects,
                      other: data.otherProjects,
                    ),
                    ContactSectionWidget(contact: data.contact),
                  ],
                ),
              ),
              if (ResponsiveLayout.isDesktop(context))
                Positioned(
                  left: 40,
                  bottom: 0,
                  child: SocialRail(socials: data.socialLinks),
                ),
              if (ResponsiveLayout.isDesktop(context))
                Positioned(
                  right: 40,
                  bottom: 0,
                  child: EmailRail(email: data.site.email),
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

  const _PortfolioNavBar({required this.nav});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveLayout.isMobile(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 48, vertical: 8),
      color: AppTheme.background.withOpacity(0.9),
      child: Row(
        children: [
          Text(
            'PK', // Placeholder for personal logo
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppTheme.accent,
                  fontFamily: 'JetBrains Mono',
                ),
          ),
          const Spacer(),
          if (!isMobile)
            Row(
              children: [
                ...nav.map((item) => Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            Text(
                              '0${nav.indexOf(item) + 1}. ',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.accent,
                                  ),
                            ),
                            Text(
                              item.label,
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: AppTheme.textPrimary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )),
                const SizedBox(width: 32),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Resume'),
                ),
              ],
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
