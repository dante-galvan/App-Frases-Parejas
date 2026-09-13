import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );
    return base.copyWith(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RomanticColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: RomanticColors.romantic700,
        secondary: RomanticColors.romantic500,
        surface: RomanticColors.darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF0E0C0D),
        selectedItemColor: RomanticColors.romantic400,
        unselectedItemColor: Color(0xFF6B6B70),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: const CardThemeData(
        color: RomanticColors.darkSurfaceAlt,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: Colors.white12,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: Colors.white),
      splashColor: RomanticColors.romantic700.withValues(alpha: 0.25),
    );
  }

  static ThemeData light() {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
      bodyColor: const Color(0xFF1A1A1A),
      displayColor: const Color(0xFF1A1A1A),
    );
    return base.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: RomanticColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: RomanticColors.romantic700,
        secondary: RomanticColors.romantic500,
        surface: RomanticColors.lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1A1A1A),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: RomanticColors.lightSurface,
        selectedItemColor: RomanticColors.romantic700,
        unselectedItemColor: Color(0xFF8A8A8F),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: Colors.black12,
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      splashColor: RomanticColors.romantic200.withValues(alpha: 0.5),
    );
  }
}
