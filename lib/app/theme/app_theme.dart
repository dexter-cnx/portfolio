import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors from DESIGN.md (The Kinetic Blueprint)
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

  static ThemeData dark() {
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
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 64,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.spaceGrotesk(
          fontSize: 48,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.spaceGrotesk(
          fontSize: 32,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          height: 1.3,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          height: 1.7,
          color: textMuted,
        ),
        bodyMedium: GoogleFonts.inter(
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
