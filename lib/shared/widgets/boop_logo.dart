import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'dart:math' as math;

/// Logo BOOP con efecto Orbit animado tipo Apple
class BoopLogo extends StatefulWidget {
  final bool darkMode;
  final LogoSize size;
  final bool iconOnly;

  const BoopLogo({
    super.key,
    required this.darkMode,
    this.size = LogoSize.medium,
    this.iconOnly = false,
  });

  @override
  State<BoopLogo> createState() => _BoopLogoState();
}

enum LogoSize { small, medium, large, icon }

class _BoopLogoState extends State<BoopLogo> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Primera partícula: 4 segundos en dirección normal
    _controller1 = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // Segunda partícula: 5 segundos en dirección reversa
    _controller2 = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    // Animación de parpadeo suave para el glow (2.5 segundos ciclo)
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _glowController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _glowController.dispose();
    super.dispose();
  }

  double get _iconSize {
    switch (widget.size) {
      case LogoSize.small:
        return 64;
      case LogoSize.medium:
        return 80;
      case LogoSize.large:
        return 128;
      case LogoSize.icon:
        return 96;
    }
  }

  double get _coreSize {
    switch (widget.size) {
      case LogoSize.small:
        return 16;
      case LogoSize.medium:
        return 20;
      case LogoSize.large:
        return 32;
      case LogoSize.icon:
        return 24;
    }
  }

  double get _particleSize {
    switch (widget.size) {
      case LogoSize.small:
      case LogoSize.medium:
      case LogoSize.icon:
        return 8;
      case LogoSize.large:
        return 12;
    }
  }

  double get _textSize {
    switch (widget.size) {
      case LogoSize.small:
        return 32;
      case LogoSize.medium:
        return 48;
      case LogoSize.large:
        return 64;
      case LogoSize.icon:
        return 40;
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon = _buildIcon();

    if (widget.iconOnly) {
      return Center(child: icon);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular el tamaño disponible para el texto
        final iconWidth = widget.size == LogoSize.large ? 128.0 : 96.0;
        final spacing = widget.size == LogoSize.large ? 32.0 : 24.0;
        final textWidth =
            _textSize * 2.5; // Aproximación del ancho del texto "BOOP"
        final totalWidth = iconWidth + spacing + textWidth;

        // Si no hay suficiente espacio, ajustar el tamaño o mostrar solo el icono
        if (constraints.maxWidth < iconWidth + spacing + 50) {
          return Center(child: icon);
        }

        // Si el espacio es limitado, reducir el spacing
        final adjustedSpacing =
            constraints.maxWidth < totalWidth ? spacing * 0.5 : spacing;

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 0,
              child: icon,
            ),
            SizedBox(width: adjustedSpacing),
            // Texto con efecto neon glow eléctrico animado
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        constraints.maxWidth - iconWidth - adjustedSpacing,
                  ),
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      final glowValue = _glowAnimation.value;
                      return Text(
                        'BOOP',
                        style: TextStyle(
                          fontSize: _textSize,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.02,
                          color: CupertinoColors.white,
                          fontFamily: '-apple-system',
                          shadows: [
                            // Glow blanco brillante interno (animado)
                            Shadow(
                              color: CupertinoColors.white
                                  .withOpacity(1.0 * glowValue),
                              blurRadius: 15 * glowValue,
                            ),
                            // Glow blanco medio (animado)
                            Shadow(
                              color: CupertinoColors.white
                                  .withOpacity(0.8 * glowValue),
                              blurRadius: 30 * glowValue,
                            ),
                            // Glow blanco suave exterior (animado)
                            Shadow(
                              color: CupertinoColors.white
                                  .withOpacity(0.5 * glowValue),
                              blurRadius: 50 * glowValue,
                            ),
                            // Glow blanco muy suave (animado)
                            Shadow(
                              color: CupertinoColors.white
                                  .withOpacity(0.3 * glowValue),
                              blurRadius: 70 * glowValue,
                            ),
                          ],
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: false,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIcon() {
    final iconSize = _iconSize;
    final particleSize = _particleSize;

    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Glow effect exterior blanco (más pronunciado)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 4,
                  ),
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.1),
                    blurRadius: 60,
                    spreadRadius: 6,
                  ),
                ],
              ),
            ),
          ),

          // Outer orbit ring con efecto glass más pronunciado
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.darkMode
                  ? CupertinoColors.white.withOpacity(0.05)
                  : CupertinoColors.white.withOpacity(0.3),
              border: Border.all(
                color: widget.darkMode
                    ? CupertinoColors.white.withOpacity(0.2)
                    : CupertinoColors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      CupertinoColors.white.withOpacity(0.1),
                      Colors.transparent,
                      CupertinoColors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Primera partícula (cyan) - rotación normal 4s, posición 3 o'clock
          AnimatedBuilder(
            animation: _controller1,
            builder: (context, child) {
              final angle = _controller1.value * 2 * math.pi;
              final baseOffset = Offset(iconSize / 2, 0); // 3 o'clock position
              final rotatedOffset = Offset(
                baseOffset.dx * math.cos(angle) -
                    baseOffset.dy * math.sin(angle),
                baseOffset.dx * math.sin(angle) +
                    baseOffset.dy * math.cos(angle),
              );
              return _buildParticle(
                iconSize: iconSize,
                particleSize: particleSize,
                offset: rotatedOffset,
                color: const Color(0xFF00F0FF),
              );
            },
          ),

          // Segunda partícula (lavanda/rosa) - rotación reversa 5s, posición 7 o'clock
          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              final angle = -_controller2.value * 2 * math.pi;
              final baseOffset = Offset(-iconSize / 2 * 0.7,
                  iconSize / 2 * 0.7); // 7 o'clock position
              final rotatedOffset = Offset(
                baseOffset.dx * math.cos(angle) -
                    baseOffset.dy * math.sin(angle),
                baseOffset.dx * math.sin(angle) +
                    baseOffset.dy * math.cos(angle),
              );
              return _buildParticle(
                iconSize: iconSize,
                particleSize: particleSize,
                offset: rotatedOffset,
                color: const Color(0xFFE8B5FF), // Lavanda más suave/rosa
              );
            },
          ),

          // Center glass core (más translúcido y suave)
          Container(
            width: _coreSize,
            height: _coreSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.darkMode
                  ? CupertinoColors.white.withOpacity(0.2)
                  : CupertinoColors.white.withOpacity(0.6),
              border: Border.all(
                color: CupertinoColors.white.withOpacity(0.8),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Gradient background blanco más suave
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CupertinoColors.white.withOpacity(0.3),
                        CupertinoColors.white.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                // Highlight más sutil
                Positioned(
                  top: 1,
                  left: 1,
                  child: Container(
                    width: _coreSize / 2.5,
                    height: _coreSize / 2.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CupertinoColors.white.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticle({
    required double iconSize,
    required double particleSize,
    required Offset offset,
    required Color color,
  }) {
    return Positioned(
      left: iconSize / 2 + offset.dx - particleSize / 2,
      top: iconSize / 2 + offset.dy - particleSize / 2,
      child: Container(
        width: particleSize,
        height: particleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          boxShadow: [
            // Glow más pronunciado
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 12,
              spreadRadius: 2,
            ),
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: CupertinoColors.white.withOpacity(0.4),
          ),
        ),
      ),
    );
  }
}
