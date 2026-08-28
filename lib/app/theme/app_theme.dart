import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Technical Editorial palette from the latest Stitch reference.
  static const Color background = Color(0xFFF9F9F8);
  static const Color surfaceLow = Color(0xFFF3F4F3);
  static const Color surfaceContainer = Color(0xFFEEEEED);
  static const Color surfaceContainerHigh = Color(0xFFE8E8E7);
  static const Color surfaceHighest = Color(0xFFE2E2E2);
  static const Color primary = Color(0xFF000000);
  static const Color accent = Color(0xFF0061A3);
  static const Color success = Color(0xFF15803D);
  static const Color error = Color(0xFFBA1A1A);
  static const Color textPrimary = Color(0xFF1A1C1C);
  static const Color textMuted = Color(0xFF444748);
  static const Color metaText = Color(0xFF6B7280);
  static const Color outline = Color(0xFFE5E7EB);
  static const Color rustAccent = Color(0xFFE98329);

  static const double contentMaxWidth = 1120;
  static const double desktopGutter = 24;
  static const double mobileGutter = 20;
  static const double sectionGap = 80;
  static const double cardRadius = 8;

  // Compatibility tokens kept while older widgets are migrated away from
  // glass/glow assumptions. Their values intentionally render as flat editorial
  // surfaces so existing components remain readable during the redesign.
  static const double glassOpacity = 0.92;
  static const double glassNavOpacity = 0.96;
  static const double glassBorderOpacity = 1;

  static Color accentGlow(double opacity) => accent.withValues(alpha: opacity);

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, background],
  );

  static ThemeData light([String locale = 'en']) {
    final isThai = locale == 'th';
    final headingFont = isThai ? GoogleFonts.sarabun : GoogleFonts.geist;
    final bodyFont = isThai ? GoogleFonts.sarabun : GoogleFonts.geist;

    final textTheme = TextTheme(
      displayLarge: headingFont(
        fontSize: 48,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.96,
      ),
      displayMedium: headingFont(
        fontSize: 40,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.6,
      ),
      headlineLarge: headingFont(
        fontSize: 32,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.32,
      ),
      headlineMedium: headingFont(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: headingFont(
        fontSize: 20,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: bodyFont(
        fontSize: 18,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: textMuted,
      ),
      bodyMedium: bodyFont(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: textMuted,
      ),
      bodySmall: bodyFont(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: metaText,
      ),
      labelLarge: GoogleFonts.jetBrainsMono(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.28,
      ),
      labelMedium: GoogleFonts.jetBrainsMono(
        fontSize: 13,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: metaText,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        surface: background,
        surfaceContainer: surfaceContainer,
        surfaceContainerLow: surfaceLow,
        surfaceContainerHigh: surfaceContainerHigh,
        error: error,
        onSurface: textPrimary,
        onSurfaceVariant: textMuted,
        outline: outline,
      ),
      textTheme: textTheme,
      dividerColor: outline,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: const BorderSide(color: outline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
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
          foregroundColor: textPrimary,
          side: const BorderSide(color: outline),
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
          foregroundColor: accent,
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLow,
        side: const BorderSide(color: outline),
        shape: const StadiumBorder(),
        labelStyle: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: textMuted,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
    );
  }

  /// Transitional alias so callers can move to [light] incrementally.
  static ThemeData dark([String locale = 'en']) => light(locale);
}
