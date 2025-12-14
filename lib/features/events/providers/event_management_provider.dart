import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/event_management_service.dart';

final eventManagementServiceProvider = Provider<EventManagementService>((ref) {
  return EventManagementService();
});

final eventStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, eventId) async {
  final service = ref.watch(eventManagementServiceProvider);
  return await service.getEventStats(eventId);
});
