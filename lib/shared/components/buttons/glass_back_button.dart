import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../../../core/branding/branding.dart';
import '../glass/glass_container.dart';

/// Botón de regresar con efecto glass y animación de zoom
class GlassBackButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const GlassBackButton({
    super.key,
    this.onPressed,
  });

  @override
  State<GlassBackButton> createState() => _GlassBackButtonState();
}

class _GlassBackButtonState extends State<GlassBackButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();

    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _zoomController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _zoomController.forward(),
      onTapUp: (_) {
        _zoomController.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _zoomController.reverse(),
      child: AnimatedBuilder(
        animation: _zoomAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _zoomAnimation.value,
            alignment: Alignment.center,
            child: GlassContainer(
              borderRadius: Branding.radiusLarge,
              padding: const EdgeInsets.all(8.0),
              child: const Icon(
                CupertinoIcons.back,
                color: CupertinoColors.white,
                size: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
