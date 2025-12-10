import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../../../shared/components/buttons/glass_button.dart';
import '../../../core/branding/branding.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/error_dialog.dart';
import '../../../shared/widgets/blurred_video_background.dart';

class EmailLoginScreen extends ConsumerStatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  ConsumerState<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _codeSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final authService = ref.read(authServiceProvider);
      await authService.signInWithEmail(email);

      if (mounted) {
        setState(() {
          _codeSent = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: e.toString(),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo electrónico';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Correo electrónico inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Iniciar sesión con Email'),
        backgroundColor: Colors.transparent,
      ),
      child: BlurredVideoBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Text(
                    _codeSent
                        ? 'Revisa tu correo'
                        : 'Ingresa tu correo electrónico',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.white,
                      shadows: [
                        Shadow(
                          color: CupertinoColors.black,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _codeSent
                        ? 'Te hemos enviado un código de verificación a ${_emailController.text}'
                        : 'Te enviaremos un código de verificación',
                    style: const TextStyle(
                      fontSize: 16,
                      color: CupertinoColors.white,
                      shadows: [
                        Shadow(
                          color: CupertinoColors.black,
                          blurRadius: 6,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (!_codeSent)
                    AuthTextField(
                      controller: _emailController,
                      placeholder: 'correo@ejemplo.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      enabled: !_isLoading,
                    )
                  else
                    const SizedBox.shrink(),
                  const Spacer(),
                  if (!_codeSent)
                    PrimaryGlassButton(
                      text: 'Enviar código',
                      onPressed: _sendCode,
                      isLoading: _isLoading,
                    )
                  else
                    Column(
                      children: [
                        PrimaryGlassButton(
                          text: 'Verificar código',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.verifyOTP,
                              arguments: {
                                'phoneOrEmail': _emailController.text.trim(),
                                'isEmail': true,
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            setState(() => _codeSent = false);
                          },
                          child: const Text(
                            'Cambiar correo',
                            style: TextStyle(
                              color: CupertinoColors.white,
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
                      ],
                    ),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.support);
                    },
                    child: const Text(
                      '¿Necesitas ayuda?',
                      style: TextStyle(
                        color: CupertinoColors.white,
                        fontSize: 14,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
