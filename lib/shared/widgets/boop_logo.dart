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

class _BoopLogoState extends State<BoopLogo>
    with TickerProviderStateMixin {
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

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        SizedBox(width: widget.size == LogoSize.large ? 32 : 24),
        // Texto con efecto glow animado (parpadeo suave)
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            final glowValue = _glowAnimation.value;
            return Text(
              'boop',
              style: TextStyle(
                fontSize: _textSize,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.02,
                color: CupertinoColors.white,
                fontFamily: '-apple-system',
                shadows: [
                  // Glow blanco interno (animado)
                  Shadow(
                    color: CupertinoColors.white.withOpacity(0.9 * glowValue),
                    blurRadius: 8 * glowValue,
                  ),
                  // Glow blanco medio (animado)
                  Shadow(
                    color: CupertinoColors.white.withOpacity(0.6 * glowValue),
                    blurRadius: 20 * glowValue,
                  ),
                  // Glow morado (animado)
                  Shadow(
                    color: const Color(0xFF8E5AFF).withOpacity(0.5 * glowValue),
                    blurRadius: 30 * glowValue,
                  ),
                  // Glow lavanda exterior (animado)
                  Shadow(
                    color: const Color(0xFFB89CFF).withOpacity(0.4 * glowValue),
                    blurRadius: 40 * glowValue,
                  ),
                ],
              ),
              overflow: TextOverflow.visible,
              softWrap: false,
            );
          },
        ),
      ],
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
          // Glow effect exterior (más suave)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8E5AFF).withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: -8,
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
                      const Color(0xFF8E5AFF).withOpacity(0.1),
                      Colors.transparent,
                      const Color(0xFFB89CFF).withOpacity(0.1),
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
              return Transform.rotate(
                angle: _controller1.value * 2 * math.pi,
                child: _buildParticle(
                  iconSize: iconSize,
                  particleSize: particleSize,
                  offset: Offset(iconSize / 2, 0), // 3 o'clock position
                  color: const Color(0xFF00F0FF),
                ),
              );
            },
          ),

          // Segunda partícula (lavanda/rosa) - rotación reversa 5s, posición 7 o'clock
          AnimatedBuilder(
            animation: _controller2,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_controller2.value * 2 * math.pi,
                child: _buildParticle(
                  iconSize: iconSize,
                  particleSize: particleSize,
                  offset: Offset(-iconSize / 2 * 0.7, iconSize / 2 * 0.7), // 7 o'clock position
                  color: const Color(0xFFE8B5FF), // Lavanda más suave/rosa
                ),
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
                // Gradient background más suave
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF8E5AFF).withOpacity(0.3),
                        const Color(0xFFB89CFF).withOpacity(0.3),
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
