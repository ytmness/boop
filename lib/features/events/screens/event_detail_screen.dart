import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/events_provider.dart';
import '../../../routes/route_names.dart';
import '../../../shared/components/buttons/glass_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));

    // Incrementar vistas cuando se carga la pantalla
    ref.listen(eventByIdProvider(eventId), (previous, next) {
      if (next.value != null) {
        ref.read(eventsServiceProvider).incrementViews(eventId);
      }
    });

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Detalle del evento'),
      ),
      child: SafeArea(
        child: eventAsync.when(
          data: (event) {
            if (event == null) {
              return const Center(child: Text('Evento no encontrado'));
            }

            final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
            final timeFormat = DateFormat('h:mm a');

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Imagen de portada
                      if (event.imageUrl != null && event.imageUrl!.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: event.imageUrl!,
                          width: double.infinity,
                          height: 300,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 300,
                            color: CupertinoColors.systemGrey5,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(
                                  CupertinoIcons.calendar,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${dateFormat.format(event.startTime)} • ${timeFormat.format(event.startTime)}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            if (event.city != null ||
                                event.address != null) ...[
                              const SizedBox(height: 12),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    CupertinoIcons.location,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      event.address ?? event.city ?? '',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (event.description != null &&
                                event.description!.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              const Text(
                                'Descripción',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                event.description!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PrimaryGlassButton(
                          text: 'Comprar Ticket',
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              RouteNames.ticketPurchasePath(eventId),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
