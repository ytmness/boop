import '../../../core/config/supabase_config.dart';
import '../../../shared/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsService {
  SupabaseClient? get _supabase => SupabaseConfig.client;
  
  bool get isDemoMode => _supabase == null;

  // Generar eventos mock para modo demo
  List<EventModel> _generateMockEvents({String? city, int limit = 20}) {
    final now = DateTime.now();
    return List.generate(limit, (index) {
      final startTime = now.add(Duration(days: index + 1, hours: index * 2));
      return EventModel(
        id: 'demo-event-$index',
        title: 'Evento Demo ${index + 1}',
        description: 'Este es un evento de demostración para que puedas ver cómo se ve la interfaz. ${city != null ? "En $city" : ""}',
        startTime: startTime,
        endTime: startTime.add(const Duration(hours: 3)),
        city: city ?? 'Ciudad Demo',
        address: 'Dirección Demo ${index + 1}',
        status: 'published',
        isPublic: true,
        createdBy: 'demo-user',
        createdAt: now.subtract(Duration(days: index)),
        viewsCount: 100 + (index * 10),
        interestedCount: 20 + (index * 5),
      );
    });
  }

  // Obtener eventos públicos por ciudad
  Future<List<EventModel>> getPublicEventsByCity({
    String? city,
    int limit = 20,
    int offset = 0,
  }) async {
    if (isDemoMode) {
      // Retornar eventos mock en modo demo
      await Future.delayed(const Duration(milliseconds: 500)); // Simular carga
      final allEvents = _generateMockEvents(city: city, limit: limit + offset);
      return allEvents.skip(offset).take(limit).toList();
    }
    try {
      var query = _supabase!
          .from('events')
          .select()
          .eq('is_public', true)
          .eq('status', 'published');

      if (city != null && city.isNotEmpty) {
        query = query.eq('city', city);
      }

      final response = await query
          .order('start_time', ascending: true)
          .range(offset, offset + limit - 1);
      
      return (response as List)
          .map((json) => EventModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos: $e');
    }
  }

  // Buscar eventos
  Future<List<EventModel>> searchEvents(String query) async {
    if (isDemoMode) {
      // Buscar en eventos mock
      await Future.delayed(const Duration(milliseconds: 300));
      final allEvents = _generateMockEvents(limit: 50);
      return allEvents.where((event) {
        final searchLower = query.toLowerCase();
        return event.title.toLowerCase().contains(searchLower) ||
            (event.description?.toLowerCase().contains(searchLower) ?? false);
      }).toList();
    }
    try {
      final response = await _supabase!
          .from('events')
          .select()
          .eq('is_public', true)
          .eq('status', 'published')
          .or('title.ilike.%$query%,description.ilike.%$query%')
          .order('start_time', ascending: true)
          .limit(50);

      return (response as List)
          .map((json) => EventModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al buscar eventos: $e');
    }
  }

  // Obtener evento por ID
  Future<EventModel?> getEventById(String eventId) async {
    if (isDemoMode) {
      // Retornar evento mock si existe
      await Future.delayed(const Duration(milliseconds: 300));
      if (eventId.startsWith('demo-event-')) {
        final index = int.tryParse(eventId.split('-').last) ?? 0;
        final now = DateTime.now();
        return EventModel(
          id: eventId,
          title: 'Evento Demo ${index + 1}',
          description: 'Este es un evento de demostración detallado. Puedes explorar todas las características de la interfaz.',
          startTime: now.add(Duration(days: index + 1, hours: index * 2)),
          endTime: now.add(Duration(days: index + 1, hours: index * 2 + 3)),
          city: 'Ciudad Demo',
          address: 'Dirección Demo ${index + 1}',
          status: 'published',
          isPublic: true,
          createdBy: 'demo-user',
          createdAt: now.subtract(Duration(days: index)),
          viewsCount: 100 + (index * 10),
          interestedCount: 20 + (index * 5),
        );
      }
      return null;
    }
    try {
      final response = await _supabase!
          .from('events')
          .select()
          .eq('id', eventId)
          .maybeSingle();

      if (response == null) return null;
      return EventModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener evento: $e');
    }
  }

  // Obtener eventos del usuario (creados o con tickets)
  Future<List<EventModel>> getUserEvents(String userId) async {
    if (isDemoMode) {
      // Retornar algunos eventos mock del usuario
      await Future.delayed(const Duration(milliseconds: 300));
      return _generateMockEvents(limit: 5);
    }
    try {
      final response = await _supabase!
          .from('events')
          .select()
          .eq('created_by', userId)
          .order('start_time', ascending: false)
          .limit(50);

      return (response as List)
          .map((json) => EventModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener eventos del usuario: $e');
    }
  }

  // Incrementar contador de vistas
  Future<void> incrementViews(String eventId) async {
    if (_supabase == null) return;
    try {
      await _supabase!.rpc('increment_event_views', params: {'event_id': eventId});
    } catch (e) {
      // Ignorar errores al incrementar vistas
    }
  }
}

