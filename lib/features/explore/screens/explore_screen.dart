import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/providers/events_provider.dart';
import '../../../shared/components/cards/glass_event_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../routes/route_names.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/branding/branding.dart';

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
                padding: const EdgeInsets.all(Branding.spacingM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Eventos destacados'),
                    const SizedBox(height: Branding.spacingM),
                    eventsAsync.when(
                      data: (events) => events.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(Branding.spacingXL),
                                child: Text(
                                  'No hay eventos disponibles',
                                  style: TextStyle(
                                    fontSize: Branding.fontSizeBody,
                                    color: CupertinoColors.secondaryLabel,
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: events.map((event) {
                                return GlassEventCard(
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
                          padding: EdgeInsets.all(Branding.spacingXL),
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      error: (error, stack) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(Branding.spacingXL),
                          child: Text(
                            'Error: $error',
                            style: const TextStyle(
                              color: CupertinoColors.systemRed,
                              fontSize: Branding.fontSizeBody,
                            ),
                          ),
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
