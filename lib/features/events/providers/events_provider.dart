import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/events_service.dart';
import '../../../shared/models/event_model.dart';

final eventsServiceProvider = Provider<EventsService>((ref) {
  return EventsService();
});

// Clase para los parámetros del provider (debe ser comparable)
class EventsQueryParams {
  final String? city;
  final int limit;
  final int offset;

  EventsQueryParams({
    this.city,
    this.limit = 20,
    this.offset = 0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventsQueryParams &&
          runtimeType == other.runtimeType &&
          city == other.city &&
          limit == other.limit &&
          offset == other.offset;

  @override
  int get hashCode => city.hashCode ^ limit.hashCode ^ offset.hashCode;
}

final publicEventsProvider =
    FutureProvider.family<List<EventModel>, EventsQueryParams>(
        (ref, params) async {
  try {
    final service = ref.watch(eventsServiceProvider);

    final result = await service
        .getPublicEventsByCity(
          city: params.city,
          limit: params.limit,
          offset: params.offset,
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () => <EventModel>[],
        );

    return result;
  } catch (e) {
    return <EventModel>[];
  }
});

final eventByIdProvider =
    FutureProvider.family<EventModel?, String>((ref, eventId) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.getEventById(eventId);
});

final searchEventsProvider =
    FutureProvider.family<List<EventModel>, String>((ref, query) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.searchEvents(query);
});

final userEventsProvider =
    FutureProvider.family<List<EventModel>, String>((ref, userId) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.getUserEvents(userId);
});
