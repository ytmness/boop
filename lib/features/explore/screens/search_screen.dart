import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../events/providers/events_provider.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../routes/route_names.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = _searchQuery.isEmpty
        ? null
        : ref.watch(searchEventsProvider(_searchQuery));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSearchTextField(
          controller: _searchController,
          placeholder: 'Buscar eventos, personas, comunidades...',
          onSubmitted: (value) {
            setState(() => _searchQuery = value);
          },
        ),
      ),
      child: SafeArea(
        child: _searchQuery.isEmpty
            ? const Center(
                child: Text('Ingresa un término de búsqueda'),
              )
            : searchResults!.when(
                data: (events) => events.isEmpty
                    ? const Center(
                        child: Text('No se encontraron resultados'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return EventCard(
                            event: event,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RouteNames.eventDetailPath(event.id),
                              );
                            },
                          );
                        },
                      ),
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

