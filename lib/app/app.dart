import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'theme/app_theme.dart';
import 'theme/app_scroll_behavior.dart';
import '../features/portfolio/presentation/pages/home_page.dart';

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
      home: PortfolioHomePage(
        onLocaleChanged: (newLocaleCode) {
          context.setLocale(Locale(newLocaleCode));
        },
      ),
    );
  }
}
