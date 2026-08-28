import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../features/portfolio/presentation/pages/experience_page.dart';
import '../features/portfolio/presentation/pages/home_page.dart';
import '../features/portfolio/presentation/pages/open_source_page.dart';
import '../features/portfolio/presentation/pages/projects_page.dart';
import '../features/project_selection/presentation/pages/project_selection_admin_page.dart';
import 'theme/app_scroll_behavior.dart';
import 'theme/app_theme.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      title: 'Portfolio',
      theme: AppTheme.light(context.locale.languageCode),
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
