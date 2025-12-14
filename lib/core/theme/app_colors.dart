import 'package:flutter/cupertino.dart';
import '../branding/branding.dart';

class AppColors {
  // Colores principales (esquema morado/lavanda)
  static const Color primary = Branding.primaryPurple;
  static const Color primaryDark = Branding.primaryPurpleDark;
  static const Color primaryLight = Branding.primaryPurpleLight;
  
  // Colores de acento
  static const Color accent = Branding.accentLavender;
  static const Color accentViolet = Branding.accentViolet;
  static const Color accentPink = Branding.accentPink;
  static const Color accentBlue = Branding.accentBlue;
  
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
  
  // Colores glass
  static const Color glassBackgroundLight = Branding.glassBackgroundLight;
  static const Color glassBackgroundDark = Branding.glassBackgroundDark;
}

