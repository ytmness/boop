import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../routes/route_names.dart';
import '../branding/boop_styles.dart';
import '../../shared/widgets/boop_glow_icon.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Pantalla de Splash premium tipo iOS con logo animado y liquid glass
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final user = ref.read(currentUserProvider);

    if (mounted) {
      final route = user != null ? RouteNames.eventsHub : RouteNames.onboarding;
      Navigator.pushReplacementNamed(
        context,
        route,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: BoopStyles.darkBackground,
      child: Stack(
        children: [
          // Fondo degradado oscuro con blur suave
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  BoopStyles.darkBackground, // #080C32
                  Colors.black,
                  BoopStyles.darkBackground.withOpacity(0.8),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),

          // Logo centrado con animación fade-in y cambio de color
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const BoopGlowIcon(size: 180),
            ),
          ),
        ],
      ),
    );
  }
}
