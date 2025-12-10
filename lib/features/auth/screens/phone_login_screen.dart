import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../../../shared/components/buttons/glass_button.dart';
import '../../../shared/components/glass/glass_container.dart';
import '../../../core/branding/branding.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/error_dialog.dart';
import '../../../shared/widgets/blurred_video_background.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final String _countryCode = '+1';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final phone = '$_countryCode${_phoneController.text.trim()}';
      final authService = ref.read(authServiceProvider);
      await authService.signInWithPhone(phone);

      if (mounted) {
        Navigator.pushNamed(
          context,
          RouteNames.verifyOTP,
          arguments: {'phoneOrEmail': phone, 'isEmail': false},
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Error',
          message: e.toString(),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu número de teléfono';
    }
    if (value.length < 10) {
      return 'Número de teléfono inválido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Iniciar sesión'),
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
                  const Text(
                    'Ingresa tu número de teléfono',
                    style: TextStyle(
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
                  const Text(
                    'Te enviaremos un código de verificación',
                    style: TextStyle(
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
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: GlassContainer(
                          borderRadius: Branding.radiusLarge,
                          padding: EdgeInsets.zero,
                          child: CupertinoTextField(
                            placeholder: _countryCode,
                            controller:
                                TextEditingController(text: _countryCode),
                            readOnly: true,
                            textAlign: TextAlign.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AuthTextField(
                          controller: _phoneController,
                          placeholder: 'Número de teléfono',
                          keyboardType: TextInputType.phone,
                          validator: _validatePhone,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PrimaryGlassButton(
                    text: 'Enviar código',
                    onPressed: _sendOTP,
                    isLoading: _isLoading,
                  ),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.pushNamed(context, RouteNames.support);
                    },
                    child: const Text(
                      '¿Problemas con el código?',
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
