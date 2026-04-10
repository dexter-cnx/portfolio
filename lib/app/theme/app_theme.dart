import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Core palette ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFF0C1324);
  static const Color surfaceLow = Color(0xFF151B2D);
  static const Color surfaceContainer = Color(0xFF191F31);
  static const Color surfaceContainerHigh = Color(0xFF23293C);
  static const Color primary = Color(0xFFFFFFFF);
  static const Color accent = Color(0xFF64FFDA);
  static const Color success = Color(0xFF5FFBD6);
  static const Color error = Color(0xFFFBB4AB);
  static const Color textPrimary = Color(0xFFDCE1FB);
  static const Color textMuted = Color(0xFFBACAC3);

  // ── Glassmorphism tokens ────────────────────────────────────────────────────
  /// White overlay opacity for glass surfaces (cards, modals).
  static const double glassOpacity = 0.06;

  /// White overlay opacity for navbar glass.
  static const double glassNavOpacity = 0.03;

  /// Border opacity for glass elements.
  static const double glassBorderOpacity = 0.14;

  /// Accent glow colour used in BoxShadow on hover.
  static Color accentGlow(double opacity) => accent.withValues(alpha: opacity);

  // ── Background gradient ─────────────────────────────────────────────────────
  /// Full-page gradient that gives depth to the dark background.
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0C1324), // base dark navy
      Color(0xFF0D1520), // slightly cooler mid
      Color(0xFF0C1824), // subtle teal-shifted bottom
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static ThemeData dark([String locale = 'en']) {
    final bool isThai = locale == 'th';

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: accent,
        secondary: accent,
        surface: background,
        surfaceContainer: surfaceContainer,
        error: error,
        onSurface: textPrimary,
        onSurfaceVariant: textMuted,
      ),
      textTheme: TextTheme(
        displayLarge: (isThai ? GoogleFonts.sarabun : GoogleFonts.spaceGrotesk)(
          fontSize: 64,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: (isThai ? GoogleFonts.sarabun : GoogleFonts.spaceGrotesk)(
          fontSize: 48,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: (isThai ? GoogleFonts.sarabun : GoogleFonts.spaceGrotesk)(
          fontSize: 32,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: (isThai ? GoogleFonts.sarabun : GoogleFonts.spaceGrotesk)(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: (isThai ? GoogleFonts.sarabun : GoogleFonts.spaceGrotesk)(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: (isThai ? GoogleFonts.sarabun : GoogleFonts.inter)(
          fontSize: 16,
          height: 1.7,
          color: textMuted,
        ),
        bodyMedium: (isThai ? GoogleFonts.sarabun : GoogleFonts.inter)(
          fontSize: 14,
          height: 1.6,
          color: textMuted,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: accent,
        ),
        labelMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          height: 1.5,
          color: textMuted,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accent,
          side: const BorderSide(color: accent, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
