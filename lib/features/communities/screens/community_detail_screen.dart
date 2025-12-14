import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/communities_provider.dart';
import '../../../shared/widgets/profile_avatar.dart';
import '../../../shared/widgets/event_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../events/providers/events_provider.dart';
import '../../../routes/route_names.dart';

class CommunityDetailScreen extends ConsumerWidget {
  final String communityId;

  const CommunityDetailScreen({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityAsync = ref.watch(communityByIdProvider(communityId));
    final user = ref.watch(currentUserProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Comunidad'),
      ),
      child: SafeArea(
        child: communityAsync.when(
          data: (community) {
            if (community == null) {
              return const Center(child: Text('Comunidad no encontrada'));
            }

            // TODO: Obtener eventos de la comunidad
            final eventsAsync = ref.watch(publicEventsProvider(
              EventsQueryParams(
                city: community.city,
                limit: 10,
                offset: 0,
              ),
            ));

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        ProfileAvatar(
                          imageUrl: community.logoUrl,
                          name: community.name,
                          radius: 50,
                          showBorder: true,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          community.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (community.city != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            community.city!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                        ],
                        if (community.description != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            community.description!,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 24),
                        if (user != null)
                          CupertinoButton.filled(
                            onPressed: () async {
                              // TODO: Implementar seguir/dejar de seguir
                            },
                            child: const Text('Seguir'),
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Eventos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        eventsAsync.when(
                          data: (events) => events.isEmpty
                              ? const Text('No hay eventos')
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
                          loading: () => const CupertinoActivityIndicator(),
                          error: (error, stack) => Text('Error: $error'),
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
