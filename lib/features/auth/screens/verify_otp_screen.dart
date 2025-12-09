import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
import '../widgets/primary_button.dart';
import '../../../routes/route_names.dart';
import '../../../shared/widgets/error_dialog.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  final String phoneOrEmail;
  final bool isEmail;

  const VerifyOTPScreen({
    super.key,
    required this.phoneOrEmail,
    this.isEmail = false,
  });

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Verificar si todos los campos están llenos
    if (index == 5 && value.isNotEmpty) {
      _verifyCode();
    }
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      if (widget.isEmail) {
        await authService.verifyEmailOTP(
          email: widget.phoneOrEmail,
          token: code,
        );
      } else {
        await authService.verifyOTP(
          phone: widget.phoneOrEmail,
          token: code,
        );
      }

      if (mounted) {
        // Navegar a la pantalla principal
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteNames.explore,
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ErrorDialog.show(
          context,
          title: 'Código inválido',
          message: e.toString(),
        );
        // Limpiar campos
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendCode() async {
    try {
      final authService = ref.read(authServiceProvider);
      if (widget.isEmail) {
        await authService.signInWithEmail(widget.phoneOrEmail);
      } else {
        await authService.signInWithPhone(widget.phoneOrEmail);
      }
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Código reenviado'),
            content: const Text('Se ha enviado un nuevo código a tu teléfono'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Verificar código'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Ingresa el código de verificación',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enviamos un código a ${widget.phoneOrEmail}',
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: CupertinoTextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CupertinoColors.separator,
                          width: 0.5,
                        ),
                      ),
                      onChanged: (value) => _onCodeChanged(index, value),
                    ),
                  );
                }),
              ),
              const Spacer(),
              PrimaryButton(
                text: 'Verificar',
                onPressed: _verifyCode,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: _resendCode,
                child: Text(
                  'Reenviar código',
                  style: TextStyle(
                    color: CupertinoColors.systemBlue,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

