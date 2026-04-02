import 'package:flutter/material.dart';

import 'theme/app_theme.dart';
import '../features/portfolio/presentation/pages/home_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      theme: AppTheme.dark(),
      home: const PortfolioHomePage(),
    );
  }
}
