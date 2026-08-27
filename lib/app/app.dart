import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../features/portfolio/presentation/pages/home_page.dart';
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
      theme: AppTheme.dark(context.locale.languageCode),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {'/admin/projects': (_) => const ProjectSelectionAdminPage()},
      home: PortfolioHomePage(
        onLocaleChanged: (newLocaleCode) {
          context.setLocale(Locale(newLocaleCode));
        },
      ),
    );
  }
}
