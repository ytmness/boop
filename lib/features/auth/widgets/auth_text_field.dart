import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../../../core/theme/app_colors.dart';
import '../../../core/branding/branding.dart';
import '../../../shared/components/glass/glass_container.dart';

class AuthTextField extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final int? maxLines;

  const AuthTextField({
    super.key,
    this.placeholder,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    return GlassContainer(
      borderRadius: Branding.radiusLarge, // Más redondeado (16px)
      backgroundColor: isDark
          ? Branding.glassBackgroundDark
          : Branding.glassBackgroundLight,
      border: Border.all(
        color: isDark
            ? CupertinoColors.white.withOpacity(0.1)
            : CupertinoColors.black.withOpacity(0.08),
        width: 0.5,
      ),
      blur: Branding.glassBlur,
      padding: EdgeInsets.zero,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLines: maxLines,
        padding: const EdgeInsets.symmetric(
          horizontal: Branding.spacingM,
          vertical: Branding.spacingM,
        ),
        decoration: const BoxDecoration(),
        prefix: prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left: Branding.spacingM),
                child: prefix,
              )
            : null,
        suffix: suffix,
        onChanged: onChanged,
        style: TextStyle(
          fontSize: Branding.fontSizeBody,
          letterSpacing: -0.4,
          color: isDark ? CupertinoColors.white : AppColors.textPrimary,
        ),
        placeholderStyle: TextStyle(
          fontSize: Branding.fontSizeBody,
          color: CupertinoColors.placeholderText,
        ),
      ),
    );
  }
}
