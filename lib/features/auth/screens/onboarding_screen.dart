import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../routes/route_names.dart';
import '../../../routes/app_router.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemRed,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  CupertinoIcons.calendar,
                  size: 60,
                  color: CupertinoColors.white,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Título
              const Text(
                'BOOP',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Subtítulo
              Text(
                'Descubre eventos increíbles\nen tu ciudad',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              
              const Spacer(flex: 3),
              
              // Botones de login
              PrimaryButton(
                text: 'Iniciar sesión con Teléfono',
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.phoneLogin);
                },
              ),
              
              const SizedBox(height: 12),
              
              PrimaryButton(
                text: 'Continuar con Apple',
                onPressed: () {
                  // TODO: Implementar Sign in with Apple
                  showCupertinoDialog(
                    context: context,
                    builder: (context) => CupertinoAlertDialog(
                      title: const Text('Próximamente'),
                      content: const Text('Sign in with Apple se implementará próximamente'),
                      actions: [
                        CupertinoDialogAction(
                          child: const Text('OK'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
                isSecondary: true,
              ),
              
              const SizedBox(height: 12),
              
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.emailLogin);
                },
                child: Text(
                  'Iniciar sesión con Email',
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                    fontSize: 16,
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Soporte
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushNamed(context, RouteNames.support);
                },
                child: Text(
                  '¿Necesitas ayuda?',
                  style: TextStyle(
                    color: CupertinoColors.secondaryLabel,
                    fontSize: 14,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

