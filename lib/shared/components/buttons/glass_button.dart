import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../../core/branding/branding.dart';
import '../animations/apple_animations.dart';

/// Botón con efecto Liquid Glass animado tipo Apple
class GlassButton extends StatefulWidget {
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
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Siempre usar texto blanco para mejor contraste sobre video/fondos oscuros
    final defaultTextColor = widget.textColor ?? CupertinoColors.white;

    return Opacity(
      opacity: widget.onPressed == null || widget.isLoading ? 0.5 : 1.0,
      child: AppleBounceAnimation(
        onTap: widget.isLoading ? null : widget.onPressed,
        child: AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              width: widget.width,
              height: widget.height ?? 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                // Sombras múltiples para efecto 3D profundo
                boxShadow: [
                  // Sombra principal grande y suave (profundidad)
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: -2,
                    offset: const Offset(0, 8),
                  ),
                  // Sombra media (profundidad intermedia)
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: -1,
                    offset: const Offset(0, 4),
                  ),
                  // Sombra cercana (borde definido)
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.15),
                    blurRadius: 8,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                  // Glow blanco sutil alrededor (efecto de luz)
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.1),
                    blurRadius: 12,
                    spreadRadius: -3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: Stack(
                  children: [
                    // Efecto liquid glass con backdrop filter
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          // Gradiente más complejo para profundidad 3D
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              CupertinoColors.white.withOpacity(0.18),
                              CupertinoColors.white.withOpacity(0.12),
                              CupertinoColors.white.withOpacity(0.08),
                              CupertinoColors.white.withOpacity(0.05),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Highlight superior (reflejo de luz en la parte superior)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: (widget.height ?? 50) * 0.4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(widget.borderRadius),
                          topRight: Radius.circular(widget.borderRadius),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                CupertinoColors.white.withOpacity(0.25),
                                CupertinoColors.white.withOpacity(0.05),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Borde interno con gradiente (profundidad)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          border: Border.all(
                            width: 1.5,
                            color: Colors.transparent,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  CupertinoColors.white.withOpacity(0.4),
                                  CupertinoColors.white.withOpacity(0.1),
                                  CupertinoColors.white.withOpacity(0.05),
                                  CupertinoColors.white.withOpacity(0.2),
                                ],
                                stops: const [0.0, 0.3, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Shimmer animado (efecto de brillo que se mueve)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(_shimmerAnimation.value, -1),
                              end: Alignment(_shimmerAnimation.value + 0.5, 1),
                              colors: [
                                Colors.transparent,
                                CupertinoColors.white.withOpacity(0.15),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Contenido del botón
                    Padding(
                      padding: widget.padding ??
                          const EdgeInsets.symmetric(
                            horizontal: Branding.spacingXL,
                            vertical: Branding.spacingM,
                          ),
                      child: Center(
                        child: widget.isLoading
                            ? const CupertinoActivityIndicator()
                            : Text(
                                widget.text,
                                style: TextStyle(
                                  color: defaultTextColor,
                                  fontSize: Branding.fontSizeHeadline,
                                  fontWeight: Branding.weightSemibold,
                                  letterSpacing: -0.4,
                                  shadows: [
                                    // Sombra de texto para profundidad
                                    Shadow(
                                      color: CupertinoColors.black.withOpacity(0.3),
                                      offset: const Offset(0, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Botón primario con efecto Liquid Glass animado
class PrimaryGlassButton extends StatefulWidget {
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
  State<PrimaryGlassButton> createState() => _PrimaryGlassButtonState();
}

class _PrimaryGlassButtonState extends State<PrimaryGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppleBounceAnimation(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Opacity(
        opacity: widget.onPressed == null || widget.isLoading ? 0.5 : 1.0,
        child: AnimatedBuilder(
          animation: _shimmerAnimation,
          builder: (context, child) {
            return Container(
              width: widget.width,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Branding.radiusLarge),
                // Sombras múltiples para efecto 3D profundo
                boxShadow: [
                  // Sombra principal grande y suave (profundidad)
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.35),
                    blurRadius: 25,
                    spreadRadius: -3,
                    offset: const Offset(0, 10),
                  ),
                  // Sombra media (profundidad intermedia)
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.25),
                    blurRadius: 18,
                    spreadRadius: -2,
                    offset: const Offset(0, 5),
                  ),
                  // Sombra cercana (borde definido)
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                  // Glow blanco sutil alrededor (efecto de luz)
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.15),
                    blurRadius: 15,
                    spreadRadius: -4,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Branding.radiusLarge),
                child: Stack(
                  children: [
                    // Efecto liquid glass con backdrop filter
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                      child: Container(
                        decoration: BoxDecoration(
                          // Gradiente más complejo para profundidad 3D
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              CupertinoColors.white.withOpacity(0.2),
                              CupertinoColors.white.withOpacity(0.15),
                              CupertinoColors.white.withOpacity(0.1),
                              CupertinoColors.white.withOpacity(0.08),
                            ],
                            stops: const [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Highlight superior (reflejo de luz en la parte superior)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 20,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Branding.radiusLarge),
                          topRight: Radius.circular(Branding.radiusLarge),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                CupertinoColors.white.withOpacity(0.3),
                                CupertinoColors.white.withOpacity(0.08),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Borde interno con gradiente (profundidad)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Branding.radiusLarge),
                          border: Border.all(
                            width: 1.5,
                            color: Colors.transparent,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Branding.radiusLarge),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  CupertinoColors.white.withOpacity(0.5),
                                  CupertinoColors.white.withOpacity(0.15),
                                  CupertinoColors.white.withOpacity(0.08),
                                  CupertinoColors.white.withOpacity(0.25),
                                ],
                                stops: const [0.0, 0.3, 0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Shimmer animado (efecto de brillo que se mueve)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Branding.radiusLarge),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(_shimmerAnimation.value, -1),
                              end: Alignment(_shimmerAnimation.value + 0.5, 1),
                              colors: [
                                Colors.transparent,
                                CupertinoColors.white.withOpacity(0.2),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Contenido del botón
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Branding.spacingXL,
                        vertical: Branding.spacingM,
                      ),
                      child: Center(
                        child: widget.isLoading
                            ? const CupertinoActivityIndicator(
                                color: CupertinoColors.white)
                            : Text(
                                widget.text,
                                style: const TextStyle(
                                  color: CupertinoColors.white,
                                  fontSize: Branding.fontSizeHeadline,
                                  fontWeight: Branding.weightSemibold,
                                  letterSpacing: -0.4,
                                  shadows: [
                                    // Sombra de texto para profundidad
                                    Shadow(
                                      color: CupertinoColors.black,
                                      offset: Offset(0, 1.5),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

