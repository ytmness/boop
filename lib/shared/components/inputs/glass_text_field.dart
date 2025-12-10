import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';

class GlassTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? placeholder;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final Widget? suffix;
  final Widget? prefix;
  final bool enabled;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;

  const GlassTextField({
    super.key,
    this.controller,
    this.placeholder,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.suffix,
    this.prefix,
    this.enabled = true,
    this.validator,
    this.focusNode,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Branding.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Branding.radiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Branding.radiusMedium),
              border: Border.all(
                color: isDark
                    ? CupertinoColors.white.withOpacity(0.15)
                    : CupertinoColors.black.withOpacity(0.1),
                width: 0.5,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        CupertinoColors.white.withOpacity(0.12),
                        CupertinoColors.white.withOpacity(0.08),
                        CupertinoColors.white.withOpacity(0.05),
                      ]
                    : [
                        CupertinoColors.white.withOpacity(0.85),
                        CupertinoColors.white.withOpacity(0.70),
                        CupertinoColors.white.withOpacity(0.60),
                      ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: CupertinoTextField(
              controller: controller,
              placeholder: placeholder,
              maxLines: maxLines,
              minLines: minLines,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onChanged: onChanged,
              onTap: onTap,
              enabled: enabled,
              focusNode: focusNode,
              padding: contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: Branding.spacingM,
                    vertical: Branding.spacingM,
                  ),
              placeholderStyle: TextStyle(
                color: isDark
                    ? CupertinoColors.white.withOpacity(0.4)
                    : CupertinoColors.black.withOpacity(0.3),
                fontSize: Branding.fontSizeBody,
              ),
              style: TextStyle(
                color: isDark ? CupertinoColors.white : CupertinoColors.black,
                fontSize: Branding.fontSizeBody,
              ),
              decoration: const BoxDecoration(),
              prefix: prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: Branding.spacingM),
                      child: prefix,
                    )
                  : null,
              suffix: suffix != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: Branding.spacingM),
                      child: suffix,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
