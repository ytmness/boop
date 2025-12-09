import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/providers/events_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../routes/route_names.dart';
import '../../profile/providers/profile_provider.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(currentProfileProvider);
    final city = profileAsync.valueOrNull?.city;
    
    final eventsAsync = ref.watch(
      publicEventsProvider({
        'city': city,
        'limit': 20,
        'offset': 0,
      }),
    );

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Explorar'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(publicEventsProvider({
                  'city': city,
                  'limit': 20,
                  'offset': 0,
                }));
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Eventos destacados'),
                    const SizedBox(height: 16),
                    eventsAsync.when(
                      data: (events) => events.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: Text(
                                  'No hay eventos disponibles',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: events.map((event) {
                                return EventCard(
                                  event: event,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      RouteNames.eventDetailPath(event.id),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text('Error: $error'),
                        ),
                      ),
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
}

