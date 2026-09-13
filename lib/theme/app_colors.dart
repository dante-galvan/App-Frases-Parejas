import 'package:flutter/material.dart';

/// Paleta romántica usada en la app, idéntica a la versión web React.
class RomanticColors {
  RomanticColors._();

  static const Color romantic50 = Color(0xFFFFF5F7);
  static const Color romantic100 = Color(0xFFFCE8ED);
  static const Color romantic200 = Color(0xFFF5C4CF);
  static const Color romantic300 = Color(0xFFEA97AB);
  static const Color romantic400 = Color(0xFFD86B86);
  static const Color romantic500 = Color(0xFFC24566);
  static const Color romantic600 = Color(0xFFA82E4D);
  static const Color romantic700 = Color(0xFF8E223E);
  static const Color romantic800 = Color(0xFF6B172E);
  static const Color romantic900 = Color(0xFF460E1D);

  /// Color principal de la app (theme-color original).
  static const Color primary = romantic700;

  /// Fondos dark (idénticos a #080607 / #0E0C0D del DeviceFrame).
  static const Color darkBg = Color(0xFF080607);
  static const Color darkSurface = Color(0xFF0E0C0D);
  static const Color darkSurfaceAlt = Color(0xFF15121A);

  /// Fondos light (idénticos a #F2EFEA / #FCFAF8).
  static const Color lightBg = Color(0xFFF2EFEA);
  static const Color lightSurface = Color(0xFFFCFAF8);
}
