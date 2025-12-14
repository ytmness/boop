import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isSecondary = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: isSecondary ? CupertinoColors.secondarySystemBackground : AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CupertinoActivityIndicator(
                color: CupertinoColors.white,
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: isSecondary
                      ? AppColors.textPrimary
                      : CupertinoColors.white,
                ),
              ),
      ),
    );
  }
}

