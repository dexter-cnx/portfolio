import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/portfolio_models.dart';

class LocalContentLoader {
  Future<PortfolioData> loadPortfolioData([String locale = 'en']) async {
    final String path = 'assets/content/portfolio_content_$locale.json';
    final String response = await rootBundle.loadString(path);
    final data = await json.decode(response);
    return PortfolioData.fromJson(data);
  }

  // Keep for debugging if needed
  Future<String> loadRawJson([String locale = 'en']) async {
    return await rootBundle.loadString('assets/content/portfolio_content_$locale.json');
  }
}

