import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

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
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderLight,
          width: 0.5,
        ),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscureText,
        keyboardType: keyboardType,
        enabled: enabled,
        maxLines: maxLines,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(),
        prefix: prefix != null
            ? Padding(
                padding: const EdgeInsets.only(left: 16),
                child: prefix,
              )
            : null,
        suffix: suffix,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 17,
          color: AppColors.textPrimary,
        ),
        placeholderStyle: TextStyle(
          fontSize: 17,
          color: CupertinoColors.placeholderText,
        ),
      ),
    );
  }
}

