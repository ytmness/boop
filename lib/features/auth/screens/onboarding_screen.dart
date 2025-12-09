import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/route_names.dart';
import '../../../shared/components/buttons/glass_button.dart';
import '../../../shared/components/animations/apple_animations.dart';
import '../../../shared/widgets/boop_logo.dart';
import '../../../core/branding/branding.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Gris muy claro tipo Apple
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFF5F5F7),
              Branding.accentLavender.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Branding.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Logo BOOP con efecto Orbit
              Center(
                child: AppleScaleTransition(
                  visible: true,
                  child: BoopLogo(
                    darkMode: false,
                    size: LogoSize.large,
                    iconOnly: false,
                  ),
                ),
              ),

              const SizedBox(height: Branding.spacingXXL),

              // Título con animación
              const AppleFadeTransition(
                visible: true,
                child: Text(
                  'BOOP',
                  style: TextStyle(
                    fontSize: Branding.fontSizeLargeTitle * 1.4,
                    fontWeight: Branding.weightBold,
                    letterSpacing: 0.37,
                    color: CupertinoColors.label,
                  ),
                ),
              ),

              const SizedBox(height: Branding.spacingM),

              // Subtítulo
              const AppleSlideTransition(
                visible: true,
                offset: Offset(0, 0.1),
                child: Text(
                  'Descubre eventos increíbles\nen tu ciudad',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Branding.fontSizeHeadline,
                    color: CupertinoColors.secondaryLabel,
                    letterSpacing: -0.4,
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
                    color: Branding.primaryPurple,
                    fontSize: Branding.fontSizeBody,
                    fontWeight: Branding.weightMedium,
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
                    color: CupertinoColors.secondaryLabel,
                    fontSize: Branding.fontSizeSubhead,
                  ),
                ),
              ),

              const SizedBox(height: Branding.spacingXL),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
