import 'package:flutter/cupertino.dart';
import '../../../core/branding/branding.dart';
import '../glass/glass_container.dart';

/// Input con efecto Glass tipo Apple
class GlassInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;

  const GlassInput({
    super.key,
    this.controller,
    this.placeholder,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return GlassContainer(
      borderRadius: Branding.radiusLarge, // Más redondeado
      backgroundColor:
          isDark ? Branding.glassBackgroundDark : Branding.glassBackgroundLight,
      border: Border.all(
        color: isDark
            ? CupertinoColors.white.withOpacity(0.1)
            : CupertinoColors.black.withOpacity(0.1),
        width: 0.5,
      ),
      padding: EdgeInsets.zero,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        obscureText: obscureText,
        enabled: enabled,
        onChanged: onChanged,
        maxLines: maxLines,
        maxLength: maxLength,
        padding: const EdgeInsets.symmetric(
          horizontal: Branding.spacingM,
          vertical: Branding.spacingM,
        ),
        style: const TextStyle(
          fontSize: Branding.fontSizeBody,
          letterSpacing: -0.4,
        ),
        placeholderStyle: const TextStyle(
          color: CupertinoColors.placeholderText,
          fontSize: Branding.fontSizeBody,
        ),
        decoration: const BoxDecoration(),
      ),
    );
  }
}
