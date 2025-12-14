import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/providers/events_provider.dart';
import '../services/payment_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/components/buttons/glass_button.dart';
import '../../../shared/widgets/error_dialog.dart';

class TicketPurchaseScreen extends ConsumerStatefulWidget {
  final String eventId;

  const TicketPurchaseScreen({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<TicketPurchaseScreen> createState() =>
      _TicketPurchaseScreenState();
}

class _TicketPurchaseScreenState extends ConsumerState<TicketPurchaseScreen> {
  int _quantity = 1;
  bool _isLoading = false;

  Future<void> _purchaseTickets() async {
    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      final paymentService = PaymentService();
      // TODO: Obtener ticketTypeId del evento
      final clientSecret = await paymentService.createPaymentIntent(
        eventId: widget.eventId,
        userId: user.id,
        ticketTypeId: 'temp', // TODO: Obtener del evento
        quantity: _quantity,
      );

      // TODO: Integrar con Stripe Payment Sheet
      // Por ahora mostrar mensaje de éxito simulado
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Compra exitosa'),
            content: const Text('Tus tickets han sido comprados exitosamente'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
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
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventAsync = ref.watch(eventByIdProvider(widget.eventId));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Comprar tickets'),
      ),
      child: SafeArea(
        child: eventAsync.when(
          data: (event) {
            if (event == null) {
              return const Center(child: Text('Evento no encontrado'));
            }

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Cantidad',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: _quantity > 1
                            ? () {
                                setState(() => _quantity--);
                              }
                            : null,
                        child: const Icon(CupertinoIcons.minus),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 24),
                      CupertinoButton(
                        padding: const EdgeInsets.all(12),
                        color: CupertinoColors.secondarySystemBackground,
                        borderRadius: BorderRadius.circular(8),
                        onPressed: () {
                          setState(() => _quantity++);
                        },
                        child: const Icon(CupertinoIcons.plus),
                      ),
                    ],
                  ),
                  const Spacer(),
                  PrimaryGlassButton(
                    text: 'Comprar tickets',
                    onPressed: _purchaseTickets,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CupertinoActivityIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }
}
