import 'dart:ui';
import 'package:flutter/cupertino.dart';
import '../../core/branding/branding.dart';

/// Icono BOOP con efecto glow animado blanco
/// Efecto de luz blanca pulsante
class BoopGlowIcon extends StatefulWidget {
  final double size;

  const BoopGlowIcon({
    super.key,
    this.size = 160,
  });

  @override
  State<BoopGlowIcon> createState() => _BoopGlowIconState();
}

class _BoopGlowIconState extends State<BoopGlowIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // Animación de intensidad de luz blanca
    _colorAnim = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(
          begin: CupertinoColors.white.withOpacity(0.6),
          end: CupertinoColors.white.withOpacity(1.0),
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(
          begin: CupertinoColors.white.withOpacity(1.0),
          end: CupertinoColors.white.withOpacity(0.6),
        ),
        weight: 1,
      ),
    ]).animate(
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
    final borderRadius = BorderRadius.circular(widget.size * 0.3);

    return AnimatedBuilder(
      animation: _colorAnim,
      builder: (context, child) {
        final currentOpacity = _colorAnim.value?.opacity ?? 1.0;

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            // Fondo blanco semi-transparente animado
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CupertinoColors.white.withOpacity(0.15 * currentOpacity),
                CupertinoColors.white.withOpacity(0.05 * currentOpacity),
              ],
            ),
            borderRadius: borderRadius,
            boxShadow: [
              // Glow principal blanco animado
              BoxShadow(
                color: CupertinoColors.white.withOpacity(0.6 * currentOpacity),
                blurRadius: 30,
                spreadRadius: 1,
              ),
              // Glow secundario más suave
              BoxShadow(
                color: CupertinoColors.white.withOpacity(0.3 * currentOpacity),
                blurRadius: 50,
                spreadRadius: 3,
              ),
              // Sombra de profundidad
              BoxShadow(
                color: CupertinoColors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: CupertinoColors.white.withOpacity(0.2 * currentOpacity),
              width: 0.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Center(
                child: Text(
                  'BOOP',
                  style: TextStyle(
                    fontSize: widget.size * 0.28,
                    fontWeight: FontWeight.w700,
                    fontFamily: Branding.fontFamilyDisplay,
                    letterSpacing: 0.02,
                    color: CupertinoColors.white,
                    shadows: [
                      // Glow blanco brillante
                      Shadow(
                        color: CupertinoColors.white
                            .withOpacity(0.9 * currentOpacity),
                        blurRadius: 15,
                      ),
                      // Glow blanco medio
                      Shadow(
                        color: CupertinoColors.white
                            .withOpacity(0.7 * currentOpacity),
                        blurRadius: 25,
                      ),
                      // Glow exterior más suave
                      Shadow(
                        color: CupertinoColors.white
                            .withOpacity(0.5 * currentOpacity),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
