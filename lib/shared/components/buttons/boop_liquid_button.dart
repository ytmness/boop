import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:ui';
import 'dart:math' as math;
import '../../../core/branding/branding.dart';

/// Botón con efecto Liquid Glass estilo Apple Vision Pro
/// Cápsula de vidrio líquido con blur real y animación de brillo pulsante
class BoopLiquidButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final double height;
  final Color? textColor;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const BoopLiquidButton({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.height = 56,
    this.textColor,
    this.width,
    this.padding,
    this.borderRadius = 32,
  });

  @override
  State<BoopLiquidButton> createState() => _BoopLiquidButtonState();
}

class _BoopLiquidButtonState extends State<BoopLiquidButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _pressController;
  late Animation<double> _pressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Animación de brillo pulsante más lenta (solo cuando está enabled)
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Animación de presión al tocar
    _pressController = AnimationController(
      duration: Branding.animationFast,
      vsync: this,
    );
    
    _pressAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Branding.curveEaseOut,
      ),
    );

    // Iniciar animación pulsante si está enabled
    if (widget.enabled && widget.onPressed != null) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(BoopLiquidButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualizar animación pulsante cuando cambia el estado enabled
    if (widget.enabled && widget.onPressed != null) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enabled && widget.onPressed != null) {
      _pressController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    if (widget.enabled && widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled && widget.onPressed != null;
    final effectiveTextColor = widget.textColor ??
        (isEnabled
            ? CupertinoColors.white
            : CupertinoColors.white.withOpacity(0.4));

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTapDown: isEnabled ? _handleTapDown : null,
        onTapUp: isEnabled ? _handleTapUp : null,
        onTapCancel: isEnabled ? _handleTapCancel : null,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _pressAnimation]),
          builder: (context, child) {
            final pulseValue = _pulseAnimation.value;
            final pressValue = _pressAnimation.value;
            
            return Transform.scale(
              scale: pressValue,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  // Sombras más pronunciadas para más presencia
                  boxShadow: [
                    // Sombra principal grande
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.25),
                      blurRadius: 40,
                      spreadRadius: -3,
                      offset: const Offset(0, 10),
                    ),
                    // Sombra media para profundidad
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.2),
                      blurRadius: 25,
                      spreadRadius: -2,
                      offset: const Offset(0, 6),
                    ),
                    // Glow pulsante blanco más visible (efecto de brillo)
                    BoxShadow(
                      color: CupertinoColors.white.withOpacity(
                        0.15 + (0.15 * pulseValue),
                      ),
                      blurRadius: 30 + (15 * pulseValue),
                      spreadRadius: -5,
                      offset: const Offset(0, -3),
                    ),
                    // Sombra cercana para definición
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipPath(
                  clipper: _LiquidBorderClipper(
                    borderRadius: widget.borderRadius,
                    pulseValue: pulseValue,
                  ),
                  child: Stack(
                    children: [
                      // BackdropFilter con blur muy intenso y distorsión (debe ir primero)
                      BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 80 + (10 * pulseValue),
                          sigmaY: 80 + (10 * pulseValue),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            // Fondo semi-transparente blanco más opaco
                            color: CupertinoColors.white.withOpacity(0.25),
                          ),
                        ),
                      ),
                      // Capa base adicional para más cuerpo y evitar bugs visuales
                      Container(
                        decoration: BoxDecoration(
                          // Fondo base más opaco para contrarrestar el video
                          color: CupertinoColors.white.withOpacity(0.15),
                        ),
                      ),
                      // Efecto de distorsión líquida adicional
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _LiquidDistortionPainter(
                            pulseValue: pulseValue,
                          ),
                          child: Container(),
                        ),
                      ),
                      // ShaderMask para highlight dinámico pulsante más visible
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CupertinoColors.white.withOpacity(
                                0.25 + (0.15 * pulseValue),
                              ),
                              CupertinoColors.white.withOpacity(0.12),
                              CupertinoColors.white.withOpacity(0.05),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.3, 0.6, 1.0],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.overlay,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(widget.borderRadius),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Borde blanco orgánico con efecto pulsante
                      CustomPaint(
                        painter: _LiquidBorderPainter(
                          pulseValue: pulseValue,
                          borderRadius: widget.borderRadius,
                        ),
                        child: Container(),
                      ),
                      // Contenido del botón
                      Padding(
                        padding: widget.padding ??
                            EdgeInsets.symmetric(
                              horizontal: Branding.spacingXL,
                              vertical: widget.height * 0.15,
                            ),
                        child: Center(
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              fontSize: Branding.fontSizeHeadline,
                              fontWeight: Branding.weightSemibold,
                              color: effectiveTextColor,
                              letterSpacing: 0.5,
                              fontFamily: '-apple-system',
                              height: 1.2,
                              // Sombra de texto sutil para mejor legibilidad
                              shadows: [
                                Shadow(
                                  color: CupertinoColors.black.withOpacity(0.3),
                                  offset: const Offset(0, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
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

/// Clipper personalizado para crear bordes orgánicos tipo líquido
class _LiquidBorderClipper extends CustomClipper<Path> {
  final double borderRadius;
  final double pulseValue;

  _LiquidBorderClipper({
    required this.borderRadius,
    required this.pulseValue,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = borderRadius;
    
    // Variación orgánica basada en pulseValue
    final wave1 = 2.0 + (1.5 * math.sin(pulseValue * 2 * math.pi));
    final wave2 = 3.0 + (2.0 * math.cos(pulseValue * 2 * math.pi + math.pi / 3));
    final wave3 = 2.5 + (1.8 * math.sin(pulseValue * 2 * math.pi + math.pi / 2));
    
    // Esquina superior izquierda
    path.moveTo(r, 0);
    
    // Parte superior con pequeña variación
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);
    
    // Lado derecho
    path.lineTo(w, h - r);
    
    // Parte inferior con efecto líquido/melting (ondas orgánicas)
    final bottomY = h;
    final waveHeight = 4.0 + (3.0 * pulseValue);
    
    // Crear ondas en la parte inferior
    path.lineTo(w * 0.85, bottomY - waveHeight * wave1);
    path.quadraticBezierTo(
      w * 0.7, bottomY - waveHeight * wave2,
      w * 0.5, bottomY - waveHeight * wave3,
    );
    path.quadraticBezierTo(
      w * 0.3, bottomY - waveHeight * wave2,
      w * 0.15, bottomY - waveHeight * wave1,
    );
    path.lineTo(0, bottomY - waveHeight * 0.5);
    
    // Lado izquierdo
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_LiquidBorderClipper oldClipper) {
    return oldClipper.borderRadius != borderRadius ||
        oldClipper.pulseValue != pulseValue;
  }
}

/// Painter para el borde líquido orgánico
class _LiquidBorderPainter extends CustomPainter {
  final double pulseValue;
  final double borderRadius;

  _LiquidBorderPainter({
    required this.pulseValue,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CupertinoColors.white.withOpacity(0.5 + (0.2 * pulseValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    final w = size.width;
    final h = size.height;
    final r = borderRadius;
    
    // Mismo path que el clipper pero para el borde
    final wave1 = 2.0 + (1.5 * math.sin(pulseValue * 2 * math.pi));
    final wave2 = 3.0 + (2.0 * math.cos(pulseValue * 2 * math.pi + math.pi / 3));
    final wave3 = 2.5 + (1.8 * math.sin(pulseValue * 2 * math.pi + math.pi / 2));
    final waveHeight = 4.0 + (3.0 * pulseValue);
    
    path.moveTo(r, 0);
    path.lineTo(w - r, 0);
    path.quadraticBezierTo(w, 0, w, r);
    path.lineTo(w, h - r);
    path.lineTo(w * 0.85, h - waveHeight * wave1);
    path.quadraticBezierTo(
      w * 0.7, h - waveHeight * wave2,
      w * 0.5, h - waveHeight * wave3,
    );
    path.quadraticBezierTo(
      w * 0.3, h - waveHeight * wave2,
      w * 0.15, h - waveHeight * wave1,
    );
    path.lineTo(0, h - waveHeight * 0.5);
    path.lineTo(0, r);
    path.quadraticBezierTo(0, 0, r, 0);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_LiquidBorderPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue;
  }
}

/// Painter para efecto de distorsión líquida interna
class _LiquidDistortionPainter extends CustomPainter {
  final double pulseValue;

  _LiquidDistortionPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    // Crear gradiente radial para efecto de distorsión
    final paint = Paint()
      ..shader = RadialGradient(
        center: Alignment(0.0, 0.8 + (0.1 * pulseValue)),
        radius: 1.2,
        colors: [
          CupertinoColors.white.withOpacity(0.1 * pulseValue),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_LiquidDistortionPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue;
  }
}

/// Variante del botón con texto en color lavanda (primaryLight)
class BoopLiquidButtonLavender extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool enabled;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const BoopLiquidButtonLavender({
    super.key,
    required this.label,
    this.onPressed,
    this.enabled = true,
    this.height = 56,
    this.width,
    this.padding,
    this.borderRadius = 32,
  });

  @override
  Widget build(BuildContext context) {
    return BoopLiquidButton(
      label: label,
      onPressed: onPressed,
      enabled: enabled,
      height: height,
      textColor: Branding.primaryPurpleLight,
      width: width,
      padding: padding,
      borderRadius: borderRadius,
    );
  }
}

