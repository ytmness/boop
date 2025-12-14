import 'package:flutter/cupertino.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TicketScannerScreen extends StatefulWidget {
  final String eventId;

  const TicketScannerScreen({
    super.key,
    required this.eventId,
  });

  @override
  State<TicketScannerScreen> createState() => _TicketScannerScreenState();
}

class _TicketScannerScreenState extends State<TicketScannerScreen> {
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Escanear ticket'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: MobileScanner(
                controller: controller,
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      _validateTicket(barcode.rawValue!);
                    }
                  }
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              child: const Text(
                'Escanea el código QR del ticket',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _validateTicket(String qrCode) async {
    // TODO: Llamar a Edge Function para validar ticket
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Ticket escaneado'),
        content: Text('Código: $qrCode'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

