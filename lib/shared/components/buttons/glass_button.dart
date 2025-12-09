import 'package:flutter/cupertino.dart';
import '../../../core/branding/branding.dart';
import '../glass/glass_container.dart';
import '../animations/apple_animations.dart';

/// Botón con efecto Glass tipo Apple
class GlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isLoading;

  const GlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = Branding.radiusMedium,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    final defaultTextColor = textColor ??
        (isDark ? CupertinoColors.white : Branding.primaryPurple);

    return Opacity(
      opacity: onPressed == null || isLoading ? 0.5 : 1.0,
      child: AppleBounceAnimation(
        onTap: isLoading ? null : onPressed,
        child: GlassContainer(
          width: width,
          height: height ?? 50,
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: Branding.spacingL,
            vertical: Branding.spacingM,
          ),
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          border: Border.all(
            color: defaultTextColor.withOpacity(0.3),
            width: 1.5,
          ),
          child: Center(
            child: isLoading
                ? const CupertinoActivityIndicator()
                : Text(
                    text,
                    style: TextStyle(
                      color: defaultTextColor,
                      fontSize: Branding.fontSizeHeadline,
                      fontWeight: Branding.weightSemibold,
                      letterSpacing: -0.4,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

/// Botón primario con gradiente morado
class PrimaryGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final bool isLoading;

  const PrimaryGlassButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppleBounceAnimation(
      onTap: isLoading ? null : onPressed,
      child: Opacity(
        opacity: onPressed == null || isLoading ? 0.5 : 1.0,
        child: Container(
          width: width,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Branding.radiusMedium),
            gradient: const LinearGradient(
              colors: [Branding.primaryPurple, Branding.primaryPurpleDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: Branding.shadowMedium,
          ),
          child: Center(
            child: isLoading
                ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                : Text(
                    text,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: Branding.fontSizeHeadline,
                      fontWeight: Branding.weightSemibold,
                      letterSpacing: -0.4,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

