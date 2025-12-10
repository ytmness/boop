import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/widgets/blurred_video_background.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _openWhatsApp() async {
    // TODO: Reemplazar con el número de WhatsApp de soporte real
    const phone = '1234567890';
    final url = Uri.parse('https://wa.me/$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _openEmail() async {
    // TODO: Reemplazar con el correo de soporte real
    const email = 'soporte@boop.com';
    final url = Uri.parse('mailto:$email?subject=Soporte BOOP');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.transparent,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Soporte'),
        backgroundColor: Colors.transparent,
      ),
      child: BlurredVideoBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                const Text(
                  '¿Necesitas ayuda?',
                  style: TextStyle(
                    fontSize: 28,
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
                const SizedBox(height: 16),
                const Text(
                  'Estamos aquí para ayudarte. Elige una opción para contactarnos:',
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
                const SizedBox(height: 48),
                CupertinoButton(
                  padding: const EdgeInsets.all(20),
                  color: CupertinoColors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: _openWhatsApp,
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.chat_bubble_2,
                        size: 24,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'WhatsApp',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  padding: const EdgeInsets.all(20),
                  color: CupertinoColors.secondarySystemBackground,
                  borderRadius: BorderRadius.circular(16),
                  onPressed: _openEmail,
                  child: const Row(
                    children: [
                      Icon(
                        CupertinoIcons.mail,
                        size: 24,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Correo electrónico',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(
                        CupertinoIcons.chevron_right,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ],
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
