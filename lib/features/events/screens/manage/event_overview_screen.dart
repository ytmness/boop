import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/event_management_provider.dart';
import '../../../../shared/widgets/stat_card.dart';

class EventOverviewScreen extends ConsumerWidget {
  final String eventId;

  const EventOverviewScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(eventStatsProvider(eventId));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Resumen'),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: statsAsync.when(
            data: (stats) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Estadísticas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    StatCard(
                      title: 'Tickets vendidos',
                      value: '${stats['tickets_sold'] ?? 0}',
                      icon: CupertinoIcons.ticket,
                    ),
                    StatCard(
                      title: 'Ingresos totales',
                      value: '\$${((stats['total_revenue'] ?? 0) as num).toStringAsFixed(0)}',
                      icon: CupertinoIcons.money_dollar,
                    ),
                    StatCard(
                      title: 'Vistas',
                      value: '${stats['views'] ?? 0}',
                      icon: CupertinoIcons.eye,
                    ),
                  ],
                ),
              ],
            ),
            loading: () => const Center(
              child: CupertinoActivityIndicator(),
            ),
            error: (error, stack) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ),
    );
  }
}

