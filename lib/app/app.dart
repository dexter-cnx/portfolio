import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../features/portfolio/presentation/pages/experience_page.dart';
import '../features/portfolio/presentation/pages/home_page.dart';
import '../features/portfolio/presentation/pages/open_source_page.dart';
import '../features/portfolio/presentation/pages/projects_page.dart';
import '../features/project_selection/presentation/pages/project_selection_admin_page.dart';
import 'theme/app_scroll_behavior.dart';
import 'theme/app_theme.dart';
import 'theme/portfolio_theme_controller.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  @override
  void initState() {
    super.initState();
    PortfolioThemeController.instance.addListener(_refresh);
    PortfolioThemeController.instance.load();
  }

  void _refresh() { if (mounted) setState(() {}); }

  @override
  void dispose() {
    PortfolioThemeController.instance.removeListener(_refresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      title: 'Portfolio',
      theme: AppTheme.light(context.locale.languageCode),
      darkTheme: AppTheme.dark(context.locale.languageCode),
      themeMode: PortfolioThemeController.instance.dark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
        '/projects': (_) => const ProjectsPage(),
        '/open-source': (_) => const OpenSourcePage(),
        '/experience': (_) => const ExperiencePage(),
        '/admin/projects': (_) => const ProjectSelectionAdminPage(),
      },
      home: PortfolioHomePage(
        onLocaleChanged: (newLocaleCode) {
          context.setLocale(Locale(newLocaleCode));
        },
      ),
    );
  }
}
