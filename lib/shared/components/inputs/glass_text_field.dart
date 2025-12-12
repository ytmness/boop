import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';
import '../glass/glass_base.dart';

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
    return GlassBase(
      padding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: Branding.spacingM,
            vertical: Branding.spacingM,
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
        padding: EdgeInsets.zero,
        showCursor: enabled,
        placeholderStyle: TextStyle(
          color: CupertinoColors.white.withOpacity(0.6),
          fontSize: Branding.fontSizeBody,
        ),
        style: TextStyle(
          color: CupertinoColors.white,
          fontSize: Branding.fontSizeBody,
        ),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
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
    );
  }
}
