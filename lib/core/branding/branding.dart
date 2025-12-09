import 'package:flutter/cupertino.dart';

/// Sistema de branding para BOOP
/// Define colores, tipografía y elementos visuales siguiendo Apple HIG
class Branding {
  // ========== PALETA DE COLORES MORADA ==========
  
  // Colores principales (actualizados según el logo Orbit)
  static const Color primaryPurple = Color(0xFF8E5AFF); // Morado principal del logo
  static const Color primaryPurpleDark = Color(0xFF6D28D9); // Morado oscuro
  static const Color primaryPurpleLight = Color(0xFFA78BFA); // Morado claro
  
  // Colores secundarios
  static const Color accentLavender = Color(0xFFC4B5FD); // Lavanda
  static const Color accentViolet = Color(0xFFB89CFF); // Violeta del logo
  static const Color accentAqua = Color(0xFF00F0FF); // Aqua del logo
  static const Color darkBackground = Color(0xFF1B1029); // Fondo oscuro del logo
  
  // Colores de fondo con efecto glass
  static const Color glassBackgroundLight = Color(0x80FFFFFF); // Blanco semi-transparente
  static const Color glassBackgroundDark = Color(0x80000000); // Negro semi-transparente
  
  // Colores de acento
  static const Color accentPink = Color(0xFFEC4899); // Rosa para acentos
  static const Color accentBlue = Color(0xFF3B82F6); // Azul para acentos
  
  // ========== TIPOGRAFÍA ==========
  
  // Fuentes (simulando San Francisco de Apple)
  static const String fontFamilyDisplay = '.SF Pro Display'; // Para títulos grandes
  static const String fontFamilyText = '.SF Pro Text'; // Para texto normal
  static const String fontFamilyRounded = '.SF Pro Rounded'; // Para elementos redondeados
  
  // Tamaños de fuente siguiendo Apple HIG
  static const double fontSizeLargeTitle = 34.0;
  static const double fontSizeTitle1 = 28.0;
  static const double fontSizeTitle2 = 22.0;
  static const double fontSizeTitle3 = 20.0;
  static const double fontSizeHeadline = 17.0;
  static const double fontSizeBody = 17.0;
  static const double fontSizeCallout = 16.0;
  static const double fontSizeSubhead = 15.0;
  static const double fontSizeFootnote = 13.0;
  static const double fontSizeCaption1 = 12.0;
  static const double fontSizeCaption2 = 11.0;
  
  // Pesos de fuente
  static const FontWeight weightUltraLight = FontWeight.w100;
  static const FontWeight weightThin = FontWeight.w200;
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemibold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightHeavy = FontWeight.w800;
  static const FontWeight weightBlack = FontWeight.w900;
  
  // ========== SPACING (siguiendo sistema 8pt de Apple) ==========
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // ========== BORDES Y RADIOS ==========
  // Todos los elementos son más redondeados para diseño Apple
  static const double radiusSmall = 12.0; // Aumentado de 8
  static const double radiusMedium = 16.0; // Aumentado de 12
  static const double radiusLarge = 20.0; // Aumentado de 16
  static const double radiusXLarge = 28.0; // Aumentado de 24
  static const double radiusRound = 999.0; // Para elementos completamente redondeados
  
  // ========== SOMBRAS (para profundidad tipo Apple) ==========
  static List<BoxShadow> get shadowSmall => [
    BoxShadow(
      color: CupertinoColors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];
  
  static List<BoxShadow> get shadowMedium => [
    BoxShadow(
      color: CupertinoColors.black.withOpacity(0.15),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get shadowLarge => [
    BoxShadow(
      color: CupertinoColors.black.withOpacity(0.2),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];
  
  // ========== EFECTOS GLASS ==========
  static const double glassBlur = 20.0;
  static const double glassOpacity = 0.8;
  
  // ========== ANIMACIONES ==========
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  
  // Curvas de animación tipo Apple
  static const Curve curveEaseInOut = Curves.easeInOut;
  static const Curve curveEaseOut = Curves.easeOut;
  static const Curve curveSpring = Curves.elasticOut;
}

