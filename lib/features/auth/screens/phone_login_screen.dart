import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/error_dialog.dart';

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _countryCode = '+1';

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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Iniciar sesión'),
      ),
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
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Te enviaremos un código de verificación',
                  style: TextStyle(
                    fontSize: 16,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: CupertinoTextField(
                        placeholder: _countryCode,
                        controller: TextEditingController(text: _countryCode),
                        readOnly: true,
                        textAlign: TextAlign.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.secondarySystemBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CupertinoColors.separator,
                            width: 0.5,
                          ),
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
                PrimaryButton(
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
                  child: Text(
                    '¿Problemas con el código?',
                    style: TextStyle(
                      color: CupertinoColors.secondaryLabel,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

