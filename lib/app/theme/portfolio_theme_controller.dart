import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared screen-theme selection. Print renderers never read this state.
final class PortfolioThemeController extends ChangeNotifier {
  PortfolioThemeController._();
  static final instance = PortfolioThemeController._();
  static const _presetKey = 'portfolio.theme.preset';
  static const _darkKey = 'portfolio.theme.dark';

  String _preset = 'indigo';
  bool _dark = false;
  String get preset => _preset;
  bool get dark => _dark;
  static const presets = <String, Color>{
    'indigo': Color(0xFF4355EA),
    'emerald': Color(0xFF087F65),
    'amber': Color(0xFFAA6911),
    'rose': Color(0xFFB83B6D),
    'slate': Color(0xFF435771),
  };
  Color get seed => presets[_preset] ?? presets['indigo']!;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_presetKey);
    if (stored != null && presets.containsKey(stored)) _preset = stored;
    _dark = prefs.getBool(_darkKey) ?? false;
    notifyListeners();
  }

  Future<void> choose(String value) async {
    if (!presets.containsKey(value)) return;
    _preset = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_presetKey, value);
  }

  Future<void> setDark(bool value) async {
    _dark = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkKey, value);
  }
}
