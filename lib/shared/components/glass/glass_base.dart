import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// Widget base reutilizable para el efecto glass-card
/// Usado por GlassTextField, GlassCard y selector de imagen para garantizar apariencia idéntica
class GlassBase extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;

  const GlassBase({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: CupertinoColors.white.withOpacity(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            // BackdropFilter para el efecto blur
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Padding(
                  padding: padding ?? EdgeInsets.zero,
                  child: child,
                ),
              ),
            ),
            // Sombra interior superior (inset 0 1px 0 rgba(255, 255, 255, 0.5))
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1,
              child: IgnorePointer(
                child: Container(
                  color: CupertinoColors.white.withOpacity(0.5),
                ),
              ),
            ),
            // Sombra interior inferior (inset 0 -1px 0 rgba(255, 255, 255, 0.1))
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 1,
              child: IgnorePointer(
                child: Container(
                  color: CupertinoColors.white.withOpacity(0.1),
                ),
              ),
            ),
            // ::before - Gradiente horizontal en la parte superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.transparent,
                        CupertinoColors.white.withOpacity(0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ::after - Gradiente vertical en el lado izquierdo
            Positioned(
              top: 0,
              left: 0,
              width: 1,
              bottom: 0,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        CupertinoColors.white.withOpacity(0.8),
                        Colors.transparent,
                        CupertinoColors.white.withOpacity(0.3),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
