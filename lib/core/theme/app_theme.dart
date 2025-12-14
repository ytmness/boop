import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import '../branding/branding.dart';

class AppTheme {
  // Tema claro con estilo Apple
  static CupertinoThemeData get lightTheme => const CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        barBackgroundColor: AppColors.backgroundSecondary,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyText,
            fontSize: Branding.fontSizeBody,
            fontWeight: Branding.weightRegular,
            letterSpacing: -0.4,
          ),
          navTitleTextStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyDisplay,
            fontSize: Branding.fontSizeLargeTitle,
            fontWeight: Branding.weightBold,
            letterSpacing: 0.37,
          ),
          navLargeTitleTextStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyDisplay,
            fontSize: Branding.fontSizeLargeTitle,
            fontWeight: Branding.weightBold,
            letterSpacing: 0.37,
          ),
          tabLabelTextStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyText,
            fontSize: Branding.fontSizeCaption1,
            fontWeight: Branding.weightMedium,
            letterSpacing: -0.08,
          ),
        ),
      );

  // Tema oscuro con estilo Apple
  static CupertinoThemeData get darkTheme => const CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryLight,
        scaffoldBackgroundColor: CupertinoColors.black,
        barBackgroundColor: CupertinoColors.systemGrey6,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyText,
            fontSize: Branding.fontSizeBody,
            fontWeight: Branding.weightRegular,
            letterSpacing: -0.4,
            color: CupertinoColors.white,
          ),
          navTitleTextStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyDisplay,
            fontSize: Branding.fontSizeLargeTitle,
            fontWeight: Branding.weightBold,
            letterSpacing: 0.37,
            color: CupertinoColors.white,
          ),
          navLargeTitleTextStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyDisplay,
            fontSize: Branding.fontSizeLargeTitle,
            fontWeight: Branding.weightBold,
            letterSpacing: 0.37,
            color: CupertinoColors.white,
          ),
          tabLabelTextStyle: TextStyle(
            inherit: false,
            fontFamily: Branding.fontFamilyText,
            fontSize: Branding.fontSizeCaption1,
            fontWeight: Branding.weightMedium,
            letterSpacing: -0.08,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      );
}
