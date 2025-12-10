import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../../core/branding/branding.dart';

/// Widget que crea un efecto "Liquid Glass" tipo Apple
/// Usa BackdropFilter para crear el efecto de vidrio esmerilado
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final double blur;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = Branding.radiusMedium,
    this.backgroundColor,
    this.blur = Branding.glassBlur,
    this.boxShadow,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: backgroundColor != null
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        CupertinoColors.white.withOpacity(0.12),
                        CupertinoColors.white.withOpacity(0.08),
                        CupertinoColors.white.withOpacity(0.05),
                      ]
                    : [
                        CupertinoColors.white.withOpacity(0.8),
                        CupertinoColors.white.withOpacity(0.6),
                        CupertinoColors.white.withOpacity(0.4),
                      ],
              ),
        color: backgroundColor,
        border: border ??
            Border.all(
              color: isDark
                  ? CupertinoColors.white.withOpacity(0.15)
                  : CupertinoColors.black.withOpacity(0.08),
              width: 0.5,
            ),
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: CupertinoColors.white.withOpacity(0.1),
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
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: backgroundColor == null && isDark
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CupertinoColors.white.withOpacity(0.08),
                        Colors.transparent,
                        CupertinoColors.white.withOpacity(0.05),
                      ],
                    )
                  : null,
            ),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Variante de GlassContainer con bordes sutiles tipo Apple
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.borderRadius = Branding.radiusMedium,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: padding ?? const EdgeInsets.all(Branding.spacingM),
        margin: margin,
        borderRadius: borderRadius,
        border: Border.all(
          color: isDark
              ? CupertinoColors.white.withOpacity(0.1)
              : CupertinoColors.black.withOpacity(0.1),
          width: 0.5,
        ),
        child: child,
      ),
    );
  }
}

