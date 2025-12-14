import 'package:flutter/cupertino.dart';
import '../../../core/branding/branding.dart';

/// Hero widget para transiciones tipo Apple
class AppleHero extends StatelessWidget {
  final String tag;
  final Widget child;
  final HeroFlightShuttleBuilder? flightShuttleBuilder;

  const AppleHero({
    super.key,
    required this.tag,
    required this.child,
    this.flightShuttleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      transitionOnUserGestures: true,
      flightShuttleBuilder: flightShuttleBuilder,
      child: child,
    );
  }
}

/// Transición personalizada tipo Apple para Hero
class AppleHeroTransition extends PageRouteBuilder {
  final Widget page;
  final String heroTag;

  AppleHeroTransition({
    required this.page,
    required this.heroTag,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Branding.animationNormal,
          reverseTransitionDuration: Branding.animationNormal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.1);
            const end = Offset.zero;
            const curve = Branding.curveEaseOut;

            final tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}

/// Transición de fade tipo Apple
class AppleFadeRoute extends PageRouteBuilder {
  final Widget page;

  AppleFadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: Branding.animationNormal,
          reverseTransitionDuration: Branding.animationNormal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
