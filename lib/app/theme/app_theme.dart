import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'portfolio_theme_controller.dart';

class AppTheme {
  static const Color background = Color(0xFFF8F7F4);
  static const Color surfaceLow = Color(0xFFF1F3F4);
  static const Color surfaceContainer = Color(0xFFE9EDF0);
  static const Color surfaceContainerHigh = Color(0xFFE2E7EA);
  static const Color surfaceHighest = Color(0xFFD9E0E4);
  static const Color primary = Color(0xFF111827);
  static const Color accent = Color(0xFF006FB9);
  static const Color success = Color(0xFF15803D);
  static const Color error = Color(0xFFBA1A1A);
  static const Color textPrimary = Color(0xFF171A1C);
  static const Color textMuted = Color(0xFF4B5256);
  static const Color metaText = Color(0xFF6B7280);
  static const Color outline = Color(0xFFD8DEE3);
  static const Color rustAccent = Color(0xFFD96A1B);

  static const double contentMaxWidth = 1120;
  static const double desktopGutter = 24;
  static const double mobileGutter = 20;
  static const double sectionGap = 80;
  static const double cardRadius = 8;

  static const double glassOpacity = 0.92;
  static const double glassNavOpacity = 0.96;
  static const double glassBorderOpacity = 1;

  static Color accentGlow(double opacity) => accent.withValues(alpha: opacity);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEFF6FB), Color(0xFFF8F7F4), Color(0xFFFBF5EF)],
    stops: [0, 0.52, 1],
  );

  static ThemeData light([String locale = 'en']) =>
      themed(locale, Brightness.light);

  static ThemeData themed(String locale, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: PortfolioThemeController.instance.seed,
      brightness: brightness,
    );
    final isThai = locale == 'th';
    final headingFont = isThai ? GoogleFonts.sarabun : GoogleFonts.geist;
    final bodyFont = isThai ? GoogleFonts.sarabun : GoogleFonts.geist;

    final textTheme = TextTheme(
      displayLarge: headingFont(
        fontSize: 48,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
        letterSpacing: -0.96,
      ),
      displayMedium: headingFont(
        fontSize: 40,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: scheme.onSurface,
        letterSpacing: -0.6,
      ),
      headlineLarge: headingFont(
        fontSize: 32,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
        letterSpacing: -0.32,
      ),
      headlineMedium: headingFont(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      titleLarge: headingFont(
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      bodyLarge: bodyFont(
        fontSize: 18,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      bodyMedium: bodyFont(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      bodySmall: bodyFont(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: scheme.onSurface,
        letterSpacing: 0.28,
      ),
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: scheme.onSurfaceVariant,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: scheme.surface,
      colorScheme: scheme,
      textTheme: textTheme,
      dividerColor: scheme.outlineVariant,
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: scheme.outlineVariant),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surface,
        selectedColor: scheme.primary,
        checkmarkColor: scheme.onPrimary,
        side: const BorderSide(color: outline),
        shape: const StadiumBorder(),
        labelStyle: GoogleFonts.jetBrainsMono(fontSize: 12, color: textMuted),
        secondaryLabelStyle: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    );
  }

  static ThemeData dark([String locale = 'en']) =>
      themed(locale, Brightness.dark);
}
