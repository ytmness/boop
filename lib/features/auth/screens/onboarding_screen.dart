import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/route_names.dart';
import '../../../shared/components/buttons/glass_button.dart';
import '../../../shared/widgets/boop_logo.dart';
import '../../../shared/widgets/boop_glow_icon.dart';
import '../../../shared/widgets/blurred_video_background.dart';
import '../../../core/branding/branding.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoFadeController;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoScaleAnimation;
  bool _showLogo = true;

  @override
  void initState() {
    super.initState();

    // Animación suave y natural para el fade-out del logo
    _logoFadeController = AnimationController(
      duration: const Duration(milliseconds: 650), // Duración suave y natural
      vsync: this,
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _logoFadeController,
        curve: Curves.easeInOutCubic, // Curva más suave y natural
      ),
    );

    _logoScaleAnimation = Tween<double>(begin: 1.0, end: 0.75).animate(
      CurvedAnimation(
        parent: _logoFadeController,
        curve: Curves.easeInOutCubic, // Curva más suave y natural
      ),
    );

    // Iniciar inmediatamente al cargar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _logoFadeController.forward().then((_) {
          if (mounted) {
            setState(() => _showLogo = false);
          }
        });
      }
    });
  }

  // Método para ocultar el logo inmediatamente cuando se navega
  void _hideLogoImmediately() {
    if (_showLogo && mounted) {
      setState(() {
        _showLogo = false;
      });
      // Detener cualquier animación en progreso
      if (_logoFadeController.isAnimating) {
        _logoFadeController.stop();
      }
    }
  }

  // Método helper para navegar con animación suave
  void _navigateWithAnimation(String routeName) {
    // Ocultar el logo inmediatamente sin animación
    _hideLogoImmediately();
    // Navegar inmediatamente sin delays
    Navigator.pushNamed(context, routeName);
  }

  @override
  void dispose() {
    _logoFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      child: BlurredVideoBackground(
        child: Stack(
          children: [
            // Contenido principal de login
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > 400
                      ? Branding.spacingXL
                      : Branding.spacingM,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),

                    // Logo BOOP con efecto Orbit (sin animación de entrada)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BoopLogo(
                        darkMode: true, // Mejor contraste sobre el video
                        size: LogoSize.large,
                        iconOnly: false,
                      ),
                    ),

                    const SizedBox(height: Branding.spacingXXL),

                    // Subtítulo
                    const Text(
                      'Descubre eventos increíbles\nen tu ciudad',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Branding.fontSizeHeadline,
                        color: CupertinoColors.white,
                        letterSpacing: -0.4,
                        shadows: [
                          Shadow(
                            color: CupertinoColors.black,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Botones de login
                    PrimaryGlassButton(
                      text: 'Iniciar sesión con Teléfono',
                      onPressed: () =>
                          _navigateWithAnimation(RouteNames.phoneLogin),
                    ),

                    const SizedBox(height: Branding.spacingM),

                    GlassButton(
                      text: 'Continuar con Apple',
                      width: double.infinity,
                      height: 50,
                      onPressed: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('Próximamente'),
                            content: const Text(
                                'Sign in with Apple se implementará próximamente'),
                            actions: [
                              CupertinoDialogAction(
                                child: const Text('OK'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: Branding.spacingM),

                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          _navigateWithAnimation(RouteNames.emailLogin),
                      child: const Text(
                        'Iniciar sesión con Email',
                        style: TextStyle(
                          color: CupertinoColors.white, // Texto blanco
                          fontSize: Branding.fontSizeBody,
                          fontWeight: Branding.weightMedium,
                          shadows: [
                            Shadow(
                              color: CupertinoColors.black,
                              blurRadius: 8,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: Branding.spacingL),

                    // Soporte
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () =>
                          _navigateWithAnimation(RouteNames.support),
                      child: const Text(
                        '¿Necesitas ayuda?',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: Branding.fontSizeSubhead,
                          shadows: [
                            Shadow(
                              color: CupertinoColors.black,
                              blurRadius: 6,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: Branding.spacingXL),
                  ],
                ),
              ),
            ),

            // Logo BoopGlowIcon que se desvanece rápidamente
            if (_showLogo)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: FadeTransition(
                      opacity: _logoOpacityAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: const BoopGlowIcon(size: 180),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
