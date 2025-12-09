import 'package:flutter/cupertino.dart';
import 'app_colors.dart';

class AppTheme {
  // Tema simplificado para evitar problemas de interpolación de TextStyles
  static const CupertinoThemeData lightTheme = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    barBackgroundColor: AppColors.backgroundSecondary,
  );

  static const CupertinoThemeData darkTheme = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.systemGrey6,
  );
}

