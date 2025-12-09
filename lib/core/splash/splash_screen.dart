import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../routes/route_names.dart';
import '../branding/branding.dart';
import '../../shared/widgets/boop_logo.dart';
import '../../features/auth/providers/auth_provider.dart';

/// Pantalla de Splash con logo y efecto Glass
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Branding.animationSlow,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Branding.curveEaseOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Branding.curveEaseInOut,
      ),
    );

    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final user = ref.read(currentUserProvider);

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        user != null ? RouteNames.explore : RouteNames.onboarding,
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
    final isDark = CupertinoTheme.brightnessOf(context) == Brightness.dark;

    return CupertinoPageScaffold(
      backgroundColor: isDark 
          ? const Color(0xFF1A1A2E) // Gris oscuro suave en lugar de negro puro
          : const Color(0xFFF5F5F7), // Gris muy claro tipo Apple
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A2E), // Gris oscuro suave
                    Branding.primaryPurpleDark.withOpacity(0.15), // Menos opaco
                  ]
                : [
                    const Color(0xFFF5F5F7), // Gris muy claro
                    Branding.accentLavender.withOpacity(0.1), // Más suave
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo BOOP con efecto Orbit
                    BoopLogo(
                      darkMode: isDark,
                      size: LogoSize.large,
                      iconOnly: false,
                    ),

                    const SizedBox(height: Branding.spacingXL),

                    // Subtítulo
                    const Text(
                      'Eventos increíbles',
                      style: TextStyle(
                        fontSize: Branding.fontSizeHeadline,
                        color: CupertinoColors.secondaryLabel,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
