import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens derived from Anti-Slop Craft specification (design.md)
class AppColors {
  // Surfaces & Backgrounds
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDim = Color(0xFFD2D9F4);
  static const Color surfaceBright = Color(0xFFFAF8FF);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);
  static const Color surfaceContainer = Color(0xFFEAEDFF);
  static const Color surfaceContainerHigh = Color(0xFFE2E7FF);
  static const Color surfaceContainerHighest = Color(0xFFDAE2FD);

  static const Color background = Color(0xFFFAF8FF);
  static const Color backgroundSubtle = Color(0xFFF8FAFC);
  static const Color onBackground = Color(0xFF131B2E);

  // Text & Outlines
  static const Color textPrimary = Color(0xFF131B2E);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color onSurfaceVariant = Color(0xFF424751);
  static const Color outline = Color(0xFF727782);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderMedium = Color(0xFFCBD5E1);

  // Primary (Flutter Navy / Blue)
  static const Color primaryDark = Color(0xFF003F74);
  static const Color primary = Color(0xFF02569B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primarySubtle = Color(0xFFEEF2FF);
  static const Color primaryFixed = Color(0xFFD4E3FF);

  // Secondary
  static const Color secondary = Color(0xFF505F76);
  static const Color secondaryContainer = Color(0xFFD0E1FB);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Semantic Status
  static const Color success = Color(0xFF10B981);
  static const Color successSubtle = Color(0xFFF0FDF4);
  static const Color successBorder = Color(0xFFBBF7D0);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSubtle = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);

  static const Color rankDark = Color(0xFF0F172A);
}

class AppRadius {
  static const double sm = 4.0;
  static const double regular = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

class AppTypography {
  static TextStyle headingTitle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle bodyText({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textSecondary,
    double? height,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle labelText({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
