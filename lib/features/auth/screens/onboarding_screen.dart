import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';
import '../../../routes/route_names.dart';
import '../../../shared/components/buttons/glass_button.dart';
import '../../../shared/components/animations/apple_animations.dart';
import '../../../shared/widgets/boop_logo.dart';
import '../../../shared/widgets/youtube_video_background.dart';
import '../../../core/branding/branding.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.black,
      child: Stack(
        children: [
          // Video de YouTube como fondo - streaming optimizado
          // Usa el video de 10 horas que siempre se verá diferente
          YoutubeVideoBackground(
            youtubeVideoId: '0WQTZvunC2Q', // ID del video de YouTube
            opacity: 0.9,
          ),
          
          // Capa de blur suave tipo liquid glass
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: CupertinoColors.black.withOpacity(0.1),
            ),
          ),
          
          // Contenido principal
          SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Branding.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo BOOP con efecto Orbit (sin título duplicado)
              Center(
                child: AppleScaleTransition(
                  visible: true,
                  child: BoopLogo(
                    darkMode: true, // Mejor contraste sobre el video
                    size: LogoSize.large,
                    iconOnly: false,
                  ),
                ),
              ),

              const SizedBox(height: Branding.spacingXXL),

              // Subtítulo con sombra para visibilidad sobre el video
              const AppleSlideTransition(
                visible: true,
                offset: Offset(0, 0.1),
                child: Text(
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
              ),

              const Spacer(flex: 3),

              // Botones de login con Glass
              AppleSlideTransition(
                visible: true,
                offset: const Offset(0, 0.2),
                child: PrimaryGlassButton(
                  text: 'Iniciar sesión con Teléfono',
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.phoneLogin);
                  },
                ),
              ),

              const SizedBox(height: Branding.spacingM),

              AppleSlideTransition(
                visible: true,
                offset: const Offset(0, 0.2),
                child: GlassButton(
                  text: 'Continuar con Apple',
                  width: double.infinity, // Mismo ancho que el botón principal
                  height: 50, // Misma altura que el botón principal
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
              ),

              const SizedBox(height: Branding.spacingM),

              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.emailLogin);
                },
                child: const Text(
                  'Iniciar sesión con Email',
                  style: TextStyle(
                    color: CupertinoColors.white,
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
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.support);
                },
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
        ],
      ),
    );
  }
}
