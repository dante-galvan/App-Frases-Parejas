import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Configuración de tipografías idéntica a la web.
class AppTypography {
  AppTypography._();

  /// Tipografía editorial (Córmorant Garamond) para frases y títulos.
  /// Se usa como `fontFamily: 'Cormorant Garamond'` con `TextStyle`.
  static TextStyle editorial({
    double fontSize = 24,
    FontWeight fontWeight = FontWeight.w500,
    FontStyle fontStyle = FontStyle.italic,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Tipografía UI (Plus Jakarta Sans) para el resto.
  static TextStyle ui({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }
}
