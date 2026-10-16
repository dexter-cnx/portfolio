import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_portfolio_starter/app/theme/portfolio_theme_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('preset selection persists and invalid presets are ignored', () async {
    SharedPreferences.setMockInitialValues({});
    final controller = PortfolioThemeController.instance;
    await controller.choose('emerald');
    expect(controller.preset, 'emerald');
    await controller.choose('unknown');
    expect(controller.preset, 'emerald');
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('portfolio.theme.preset'), 'emerald');
    await controller.setDark(true);
    expect(prefs.getBool('portfolio.theme.dark'), isTrue);
    await controller.setDark(false);
    await controller.choose('indigo');
  });
}
