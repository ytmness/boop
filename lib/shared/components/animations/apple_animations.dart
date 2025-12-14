import 'package:flutter/cupertino.dart';
import '../../../core/branding/branding.dart';

/// Animación de fade in/out tipo Apple
class AppleFadeTransition extends StatelessWidget {
  final Widget child;
  final bool visible;
  final Duration duration;

  const AppleFadeTransition({
    super.key,
    required this.child,
    required this.visible,
    this.duration = Branding.animationNormal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Branding.curveEaseOut,
      switchOutCurve: Branding.curveEaseInOut,
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: visible
          ? KeyedSubtree(key: const ValueKey('visible'), child: child)
          : const SizedBox.shrink(),
    );
  }
}

/// Animación de escala tipo Apple
class AppleScaleTransition extends StatelessWidget {
  final Widget child;
  final bool visible;
  final Duration duration;

  const AppleScaleTransition({
    super.key,
    required this.child,
    required this.visible,
    this.duration = Branding.animationNormal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.8,
      duration: duration,
      curve: Branding.curveEaseOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: duration,
        child: child,
      ),
    );
  }
}

/// Animación de slide tipo Apple
class AppleSlideTransition extends StatelessWidget {
  final Widget child;
  final bool visible;
  final Offset offset;
  final Duration duration;

  const AppleSlideTransition({
    super.key,
    required this.child,
    required this.visible,
    this.offset = const Offset(0, 0.1),
    this.duration = Branding.animationNormal,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: visible ? Offset.zero : offset,
      duration: duration,
      curve: Branding.curveEaseOut,
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        duration: duration,
        child: child,
      ),
    );
  }
}

/// Animación de bounce tipo Apple (para botones)
class AppleBounceAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const AppleBounceAnimation({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<AppleBounceAnimation> createState() => _AppleBounceAnimationState();
}

class _AppleBounceAnimationState extends State<AppleBounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Branding.animationFast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Branding.curveEaseOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
