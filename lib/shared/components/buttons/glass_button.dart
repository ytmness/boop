import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import '../../../core/branding/branding.dart';

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
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _glassOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para el efecto de zoom al presionar - animación más fluida
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
      value: 0.0, // Valor inicial
    );

    // Animación de zoom del contenido interno (efecto lupa)
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic, // Curva más fluida y suave
      ),
    );

    // Animación de blur que aumenta MUCHO cuando se presiona el botón
    // Casi censura el video con difuminación extrema (efecto vidrio)
    // Debe inicializarse después de _zoomController
    _blurAnimation = Tween<double>(begin: 30.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Animación de opacidad del vidrio que aumenta cuando está presionado
    _glassOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOutSine, // Curva más suave para movimiento fluido
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Usar texto blanco para mejor contraste sobre fondo difuminado
    final defaultTextColor = widget.textColor ?? CupertinoColors.white;

    return Opacity(
      opacity: widget.onPressed == null || widget.isLoading ? 0.5 : 1.0,
      child: GestureDetector(
        onTapDown: widget.isLoading
            ? null
            : (_) {
                _zoomController.forward();
              },
        onTapUp: widget.isLoading
            ? null
            : (_) {
                _zoomController.reverse();
                widget.onPressed?.call();
              },
        onTapCancel: widget.isLoading
            ? null
            : () {
                _zoomController.reverse();
              },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _shimmerController,
            _zoomController,
            _blurAnimation,
            _glassOpacityAnimation
          ]),
          builder: (context, child) {
            // Escala del botón completo para efecto de hover/presionado visible
            final buttonScale = 1.0 +
                (_zoomController.value * 0.08); // Crece 8% cuando se presiona

            return Transform.scale(
              scale: buttonScale,
              alignment: Alignment.center,
              child: Container(
                width: widget.width,
                height: widget.height ?? 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  // Sombras muy sutiles para botones transparentes
                  boxShadow: [
                    // Sombra principal muy suave
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    ),
                    // Glow blanco muy sutil alrededor
                    BoxShadow(
                      color: CupertinoColors.white.withOpacity(0.08),
                      blurRadius: 12,
                      spreadRadius: -1,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: Stack(
                    children: [
                      // Efecto liquid glass con backdrop filter - efecto lupa/vaso
                      // El Positioned.fill + Transform.scale amplía el fondo como una lupa
                      Positioned.fill(
                        child: Transform.scale(
                          scale: _zoomAnimation.value,
                          alignment: Alignment.center,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: _blurAnimation.value,
                                sigmaY: _blurAnimation.value),
                            child: Container(
                              decoration: BoxDecoration(
                                // Gradiente con centro muy transparente - botones casi invisibles
                                // Cuando está presionado, aumenta opacidad para efecto vidrio
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  radius: 1.2,
                                  colors: [
                                    CupertinoColors.white.withOpacity(0.01 +
                                        (_glassOpacityAnimation.value *
                                            0.15)), // Centro casi invisible, aumenta cuando presionado
                                    CupertinoColors.white.withOpacity(0.02 +
                                        (_glassOpacityAnimation.value * 0.18)),
                                    CupertinoColors.white.withOpacity(0.03 +
                                        (_glassOpacityAnimation.value * 0.22)),
                                    CupertinoColors.white.withOpacity(0.05 +
                                        (_glassOpacityAnimation.value *
                                            0.25)), // Bordes más opacos cuando presionado
                                  ],
                                  stops: const [0.0, 0.4, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Highlight superior más sutil (menos opaco)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: (widget.height ?? 50) * 0.3,
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
                                  CupertinoColors.white.withOpacity(0.04),
                                  CupertinoColors.white.withOpacity(0.01),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Borde brillante con luces en los contornos
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            border: Border.all(
                              width: 2.0,
                              color: Colors.transparent,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            child: Stack(
                              children: [
                                // Capa base transparente en el centro
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment.center,
                                      radius: 1.5,
                                      colors: [
                                        Colors.transparent,
                                        CupertinoColors.white.withOpacity(0.03),
                                        CupertinoColors.white.withOpacity(0.08),
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ),
                                  ),
                                ),
                                // Bordes brillantes con gradiente
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        widget.borderRadius),
                                    border: Border.all(
                                      width: 1.0,
                                      color: CupertinoColors.white
                                          .withOpacity(0.25),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          widget.borderRadius),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          CupertinoColors.white.withOpacity(
                                              0.25), // Esquinas superiores sutiles
                                          CupertinoColors.white
                                              .withOpacity(0.1),
                                          CupertinoColors.white
                                              .withOpacity(0.03),
                                          CupertinoColors.white.withOpacity(
                                              0.15), // Esquinas inferiores sutiles
                                        ],
                                        stops: const [0.0, 0.3, 0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Shimmer animado (efecto de brillo que se mueve de forma fluida)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(_shimmerAnimation.value, -1),
                                end:
                                    Alignment(_shimmerAnimation.value + 0.6, 1),
                                colors: [
                                  Colors.transparent,
                                  CupertinoColors.white.withOpacity(0.08),
                                  CupertinoColors.white.withOpacity(0.08),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.4, 0.6, 1.0],
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
                                        color: CupertinoColors.black,
                                        offset: const Offset(0, 1.5),
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
    with TickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _glassOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Controlador para el efecto de zoom al presionar - animación más fluida
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
      value: 0.0, // Valor inicial
    );

    // Animación de zoom del contenido interno (efecto lupa)
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic, // Curva más fluida y suave
      ),
    );

    // Animación de blur que aumenta MUCHO cuando se presiona el botón
    // Casi censura el video con difuminación extrema (efecto vidrio)
    // Debe inicializarse después de _zoomController
    _blurAnimation = Tween<double>(begin: 30.0, end: 180.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Animación de opacidad del vidrio que aumenta cuando está presionado
    _glassOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOutSine, // Curva más suave para movimiento fluido
      ),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.onPressed == null || widget.isLoading ? 0.5 : 1.0,
      child: GestureDetector(
        onTapDown: widget.isLoading
            ? null
            : (_) {
                _zoomController.forward();
              },
        onTapUp: widget.isLoading
            ? null
            : (_) {
                _zoomController.reverse();
                widget.onPressed?.call();
              },
        onTapCancel: widget.isLoading
            ? null
            : () {
                _zoomController.reverse();
              },
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _shimmerController,
            _zoomController,
            _blurAnimation,
            _glassOpacityAnimation
          ]),
          builder: (context, child) {
            // Escala del botón completo para efecto de hover/presionado visible
            final buttonScale = 1.0 +
                (_zoomController.value * 0.08); // Crece 8% cuando se presiona

            return Transform.scale(
              scale: buttonScale,
              alignment: Alignment.center,
              child: Container(
                width: widget.width,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Branding.radiusLarge),
                  // Sombras muy sutiles para botones transparentes
                  boxShadow: [
                    // Sombra principal muy suave
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: -2,
                      offset: const Offset(0, 4),
                    ),
                    // Glow blanco muy sutil alrededor
                    BoxShadow(
                      color: CupertinoColors.white.withOpacity(0.08),
                      blurRadius: 12,
                      spreadRadius: -1,
                      offset: const Offset(0, -1),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Branding.radiusLarge),
                  child: Stack(
                    children: [
                      // Efecto liquid glass con backdrop filter - efecto lupa/vaso
                      // El Positioned.fill + Transform.scale amplía el fondo como una lupa
                      Positioned.fill(
                        child: Transform.scale(
                          scale: _zoomAnimation.value,
                          alignment: Alignment.center,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: _blurAnimation.value,
                                sigmaY: _blurAnimation.value),
                            child: Container(
                              decoration: BoxDecoration(
                                // Gradiente radial con centro muy transparente - botones casi invisibles
                                // Cuando está presionado, aumenta opacidad para efecto vidrio
                                gradient: RadialGradient(
                                  center: Alignment.center,
                                  radius: 1.2,
                                  colors: [
                                    CupertinoColors.white.withOpacity(0.01 +
                                        (_glassOpacityAnimation.value *
                                            0.15)), // Centro casi invisible, aumenta cuando presionado
                                    CupertinoColors.white.withOpacity(0.02 +
                                        (_glassOpacityAnimation.value * 0.18)),
                                    CupertinoColors.white.withOpacity(0.03 +
                                        (_glassOpacityAnimation.value * 0.22)),
                                    CupertinoColors.white.withOpacity(0.05 +
                                        (_glassOpacityAnimation.value *
                                            0.25)), // Bordes más opacos cuando presionado
                                  ],
                                  stops: const [0.0, 0.4, 0.7, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Highlight superior más sutil (menos opaco)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: 50 *
                            0.3, // Mismo cálculo proporcional que GlassButton
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
                                  CupertinoColors.white.withOpacity(0.04),
                                  CupertinoColors.white.withOpacity(0.01),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Borde brillante con luces en los contornos
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Branding.radiusLarge),
                            border: Border.all(
                              width: 2.0,
                              color: Colors.transparent,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(Branding.radiusLarge),
                            child: Stack(
                              children: [
                                // Capa base transparente en el centro
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment.center,
                                      radius: 1.5,
                                      colors: [
                                        Colors.transparent,
                                        CupertinoColors.white.withOpacity(0.03),
                                        CupertinoColors.white.withOpacity(0.08),
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ),
                                  ),
                                ),
                                // Bordes brillantes con gradiente
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Branding.radiusLarge),
                                    border: Border.all(
                                      width: 1.0,
                                      color: CupertinoColors.white
                                          .withOpacity(0.25),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Branding.radiusLarge),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          CupertinoColors.white.withOpacity(
                                              0.25), // Esquinas superiores sutiles
                                          CupertinoColors.white
                                              .withOpacity(0.1),
                                          CupertinoColors.white
                                              .withOpacity(0.03),
                                          CupertinoColors.white.withOpacity(
                                              0.15), // Esquinas inferiores sutiles
                                        ],
                                        stops: const [0.0, 0.3, 0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Shimmer animado (efecto de brillo que se mueve de forma fluida)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Branding.radiusLarge),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(_shimmerAnimation.value, -1),
                                end:
                                    Alignment(_shimmerAnimation.value + 0.6, 1),
                                colors: [
                                  Colors.transparent,
                                  CupertinoColors.white.withOpacity(0.08),
                                  CupertinoColors.white.withOpacity(0.08),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.4, 0.6, 1.0],
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
                                    color:
                                        CupertinoColors.white, // Texto blanco
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
              ),
            );
          },
        ),
      ),
    );
  }
}
