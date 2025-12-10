import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/branding/branding.dart';

/// Logo animado "boop" con efecto neon glow y liquid glass
/// Muestra el texto con degradado azul → magenta y glow animado
class AnimatedBoopLogo extends StatefulWidget {
  final double size;

  const AnimatedBoopLogo({
    super.key,
    this.size = 140,
  });

  @override
  State<AnimatedBoopLogo> createState() => _AnimatedBoopLogoState();
}

class _AnimatedBoopLogoState extends State<AnimatedBoopLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        final glowValue = _glowAnimation.value;
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(Branding.radiusXLarge),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                // Degradado de fondo glass blanco
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.white.withOpacity(0.15),
                    CupertinoColors.white.withOpacity(0.1),
                    CupertinoColors.white.withOpacity(0.05),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(Branding.radiusXLarge),
                border: Border.all(
                  color: CupertinoColors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  // Glow blanco
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.5 * glowValue),
                    blurRadius: 30 * glowValue,
                    spreadRadius: 2,
                  ),
                  // Glow blanco suave
                  BoxShadow(
                    color: CupertinoColors.white.withOpacity(0.3 * glowValue),
                    blurRadius: 50 * glowValue,
                    spreadRadius: 4,
                  ),
                  // Sombra de profundidad
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'boop',
                style: TextStyle(
                  fontSize: widget.size * 0.26,
                  fontWeight: FontWeight.w700,
                  fontFamily: Branding.fontFamilyDisplay,
                  letterSpacing: 0.02,
                  color: CupertinoColors.white,
                  shadows: [
                    // Glow blanco brillante interno (más intenso)
                    Shadow(
                      color: CupertinoColors.white.withOpacity(1.0 * glowValue),
                      blurRadius: 20 * glowValue,
                    ),
                    // Glow blanco medio
                    Shadow(
                      color: CupertinoColors.white.withOpacity(0.8 * glowValue),
                      blurRadius: 35 * glowValue,
                    ),
                    // Glow blanco suave
                    Shadow(
                      color: CupertinoColors.white.withOpacity(0.6 * glowValue),
                      blurRadius: 50 * glowValue,
                    ),
                    // Glow blanco muy suave exterior
                    Shadow(
                      color: CupertinoColors.white.withOpacity(0.4 * glowValue),
                      blurRadius: 70 * glowValue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

