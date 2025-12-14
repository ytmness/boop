import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/event_management_provider.dart';
import '../providers/events_provider.dart';
import '../../../shared/widgets/stat_card.dart';
import '../../../routes/route_names.dart';

class ManageEventScreen extends ConsumerWidget {
  final String eventId;

  const ManageEventScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));
    final statsAsync = ref.watch(eventStatsProvider(eventId));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Administrar evento'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    eventAsync.when(
                      data: (event) {
                        if (event == null) {
                          return const Text('Evento no encontrado');
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Resumen',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            statsAsync.when(
                              data: (stats) => Row(
                                children: [
                                  Expanded(
                                    child: StatCard(
                                      title: 'Tickets vendidos',
                                      value: '${stats['tickets_sold'] ?? 0}',
                                      icon: CupertinoIcons.ticket,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: StatCard(
                                      title: 'Ingresos',
                                      value: '\$${((stats['total_revenue'] ?? 0) as num).toStringAsFixed(0)}',
                                      icon: CupertinoIcons.money_dollar,
                                    ),
                                  ),
                                ],
                              ),
                              loading: () => const CupertinoActivityIndicator(),
                              error: (_, __) => const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'Herramientas',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildMenuItem(
                              context,
                              'Editar evento',
                              CupertinoIcons.pencil,
                              () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.editEventPath(eventId),
                                );
                              },
                            ),
                            _buildMenuItem(
                              context,
                              'Equipo',
                              CupertinoIcons.person_2,
                              () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.eventTeamPath(eventId),
                                );
                              },
                            ),
                            _buildMenuItem(
                              context,
                              'Tickets',
                              CupertinoIcons.ticket,
                              () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.ticketsManagementPath(eventId),
                                );
                              },
                            ),
                            _buildMenuItem(
                              context,
                              'Órdenes',
                              CupertinoIcons.shopping_cart,
                              () {
                                Navigator.pushNamed(
                                  context,
                                  RouteNames.ordersListPath(eventId),
                                );
                              },
                            ),
                          ],
                        );
                      },
                      loading: () => const CupertinoActivityIndicator(),
                      error: (error, stack) => Text('Error: $error'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: CupertinoColors.secondarySystemBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 17),
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: CupertinoColors.secondaryLabel,
            ),
          ],
        ),
      ),
    );
  }
}

