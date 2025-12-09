import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/events_service.dart';
import '../../../shared/models/event_model.dart';

final eventsServiceProvider = Provider<EventsService>((ref) {
  return EventsService();
});

final publicEventsProvider = FutureProvider.family<List<EventModel>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.getPublicEventsByCity(
    city: params['city'] as String?,
    limit: params['limit'] as int? ?? 20,
    offset: params['offset'] as int? ?? 0,
  );
});

final eventByIdProvider = FutureProvider.family<EventModel?, String>((ref, eventId) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.getEventById(eventId);
});

final searchEventsProvider = FutureProvider.family<List<EventModel>, String>((ref, query) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.searchEvents(query);
});

final userEventsProvider = FutureProvider.family<List<EventModel>, String>((ref, userId) async {
  final service = ref.watch(eventsServiceProvider);
  return await service.getUserEvents(userId);
});

