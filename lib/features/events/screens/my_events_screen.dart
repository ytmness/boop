import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/events_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../routes/route_names.dart';

class MyEventsScreen extends ConsumerWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Mis eventos'),
        ),
        child: Center(child: Text('Debes iniciar sesión')),
      );
    }

    final eventsAsync = ref.watch(userEventsProvider(user.id));

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Mis eventos'),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                ref.invalidate(userEventsProvider(user.id));
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Eventos creados'),
                    const SizedBox(height: 16),
                    eventsAsync.when(
                      data: (events) => events.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No has creado ningún evento',
                                style: TextStyle(
                                  color: CupertinoColors.secondaryLabel,
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
                                      RouteNames.manageEventPath(event.id),
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
        ),
      ),
    );
  }
}

