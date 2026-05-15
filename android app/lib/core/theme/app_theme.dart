import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.parchment,
      colorScheme: const ColorScheme.light(
        primary: AppColors.navy,
        secondary: AppColors.gold,
        surface: AppColors.white,
        onPrimary: AppColors.white,
        onSecondary: AppColors.ink,
        onSurface: AppColors.ink,
      ),
      textTheme: baseTextTheme.copyWith(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 46,
          height: 1.05,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 34,
          height: 1.1,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        headlineMedium: GoogleFonts.playfairDisplay(
          fontSize: 28,
          height: 1.15,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.7,
          color: AppColors.ink,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.6,
          color: AppColors.mutedText,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
