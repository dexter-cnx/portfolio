import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/portfolio_models.dart';

class LocalContentLoader {
  Future<PortfolioData> loadPortfolioData() async {
    final String response = await rootBundle.loadString('assets/content/portfolio_content.json');
    final data = await json.decode(response);
    return PortfolioData.fromJson(data);
  }

  // Keep for debugging if needed
  Future<String> loadRawJson() async {
    return await rootBundle.loadString('assets/content/portfolio_content.json');
  }
}
