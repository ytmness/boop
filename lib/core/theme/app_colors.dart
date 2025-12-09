import 'package:flutter/cupertino.dart';

class AppColors {
  // Colores principales (rojo en lugar de azul según preferencias)
  static const Color primary = Color(0xFFDC2626); // Rojo principal
  static const Color primaryDark = Color(0xFFB91C1C);
  static const Color primaryLight = Color(0xFFEF4444);
  
  // Colores de acento
  static const Color accent = Color(0xFFFF6B6B);
  
  // Colores de fondo
  static const Color background = CupertinoColors.systemBackground;
  static const Color backgroundSecondary = CupertinoColors.secondarySystemBackground;
  static const Color backgroundTertiary = CupertinoColors.tertiarySystemBackground;
  
  // Colores de texto
  static const Color textPrimary = CupertinoColors.label;
  static const Color textSecondary = CupertinoColors.secondaryLabel;
  static const Color textTertiary = CupertinoColors.tertiaryLabel;
  
  // Colores de estado
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Colores de borde
  static const Color border = CupertinoColors.separator;
  static const Color borderLight = CupertinoColors.opaqueSeparator;
  
  // Colores de overlay
  static const Color overlay = Color(0x80000000);
}

