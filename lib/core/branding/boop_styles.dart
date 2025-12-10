import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';

/// Estilos específicos de BOOP con identidad morada/eléctrica
/// Clases utilitarias para efectos neon, glow y glassmorphism mejorado
class BoopStyles {
  // ========== PALETA MORADA/ELÉCTRICA ==========
  static const Color primaryPurple = Color(0xFF8E5AFF);
  static const Color accentViolet = Color(0xFFB89CFF);
  static const Color accentAqua = Color(0xFF00F0FF);
  static const Color darkBackground = Color(0xFF080C32);
  static const Color darkBackgroundAlt = Color(0xFF0A0F3A);

  // ========== EFECTOS NEON GLOW ==========

  /// Glow blanco para texto principal
  static List<Shadow> get boopGlowPurple => [
        Shadow(
          color: CupertinoColors.white.withOpacity(0.9),
          blurRadius: 15,
        ),
        Shadow(
          color: CupertinoColors.white.withOpacity(0.7),
          blurRadius: 30,
        ),
        Shadow(
          color: CupertinoColors.white.withOpacity(0.5),
          blurRadius: 50,
        ),
      ];

  /// Glow aqua/cyan para acentos
  static List<Shadow> get boopGlowAqua => [
        Shadow(
          color: accentAqua.withOpacity(0.8),
          blurRadius: 15,
        ),
        Shadow(
          color: accentAqua.withOpacity(0.5),
          blurRadius: 30,
        ),
        Shadow(
          color: accentAqua.withOpacity(0.3),
          blurRadius: 50,
        ),
      ];

  /// Glow blanco combinado para elementos destacados
  static List<Shadow> get boopGlowElectric => [
        Shadow(
          color: CupertinoColors.white.withOpacity(1.0),
          blurRadius: 20,
        ),
        Shadow(
          color: CupertinoColors.white.withOpacity(0.8),
          blurRadius: 35,
        ),
        Shadow(
          color: CupertinoColors.white.withOpacity(0.6),
          blurRadius: 50,
        ),
        Shadow(
          color: CupertinoColors.white.withOpacity(0.4),
          blurRadius: 70,
        ),
      ];

  /// Glow suave blanco para texto secundario
  static List<Shadow> get boopGlowSoft => [
        Shadow(
          color: CupertinoColors.white.withOpacity(0.6),
          blurRadius: 15,
        ),
        Shadow(
          color: CupertinoColors.white.withOpacity(0.4),
          blurRadius: 30,
        ),
      ];

  // ========== GLASSMORPHISM MEJORADO ==========

  /// Degradado de fondo para glass panels (menos blanco, más azul oscuro)
  static LinearGradient get glassGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          darkBackground.withOpacity(0.3),
          Colors.black.withOpacity(0.2),
          darkBackground.withOpacity(0.1),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

  /// Degradado de borde blanco para glass panels
  static LinearGradient get glassBorderGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          CupertinoColors.white.withOpacity(0.3),
          CupertinoColors.white.withOpacity(0.15),
          CupertinoColors.white.withOpacity(0.1),
        ],
      );

  /// BoxShadow blanco para profundidad en glass panels
  static List<BoxShadow> get glassShadow => [
        BoxShadow(
          color: CupertinoColors.white.withOpacity(0.15),
          blurRadius: 20,
          spreadRadius: -5,
          offset: const Offset(0, 10),
        ),
        BoxShadow(
          color: CupertinoColors.black.withOpacity(0.1),
          blurRadius: 30,
          spreadRadius: -10,
          offset: const Offset(0, 15),
        ),
      ];

  /// BoxShadow blanco para efecto neon en elementos interactivos
  static List<BoxShadow> get neonShadow => [
        BoxShadow(
          color: CupertinoColors.white.withOpacity(0.5),
          blurRadius: 15,
          spreadRadius: 2,
        ),
        BoxShadow(
          color: CupertinoColors.white.withOpacity(0.3),
          blurRadius: 25,
          spreadRadius: 4,
        ),
        BoxShadow(
          color: CupertinoColors.white.withOpacity(0.2),
          blurRadius: 40,
          spreadRadius: 6,
        ),
      ];

  // ========== FONDOS DEGRADADOS ==========

  /// Fondo principal degradado entre #080C32 y negro
  static BoxDecoration get darkGradientBackground => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            darkBackground,
            Colors.black,
            darkBackground.withOpacity(0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      );

  /// Fondo claro con toque morado
  static BoxDecoration get lightGradientBackground => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF5F5F7),
            accentLavender.withOpacity(0.1),
            primaryPurple.withOpacity(0.05),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      );

  // ========== ESTILOS DE TEXTO ==========

  /// Estilo para títulos principales con glow
  static TextStyle boopTitle({double fontSize = 34, Color? color}) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.37,
        color: color ?? CupertinoColors.white,
        shadows: boopGlowPurple,
        fontFamily: '-apple-system',
      );

  /// Estilo para texto destacado con glow suave
  static TextStyle boopHeadline({double fontSize = 17, Color? color}) =>
      TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        color: color ?? CupertinoColors.white,
        shadows: boopGlowSoft,
        fontFamily: '-apple-system',
      );

  /// Estilo para texto secundario
  static TextStyle boopBody({double fontSize = 17, Color? color}) => TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.4,
        color: color ?? CupertinoColors.secondaryLabel,
        fontFamily: '-apple-system',
      );

  // Acceso a accentLavender desde Branding
  static Color get accentLavender => const Color(0xFFE8D5FF);
}
