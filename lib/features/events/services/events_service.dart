import 'dart:async';
import '../../../core/config/supabase_config.dart';
import '../../../shared/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  bool get isDemoMode => _supabase == null;

  // Generar eventos mock para modo demo
  List<EventModel> _generateMockEvents({String? city, int limit = 20}) {
    final now = DateTime.now();
    final eventTitles = [
      'Festival de Música Electrónica',
      'Concierto de Rock Alternativo',
      'Noche de Stand Up Comedy',
      'Workshop de Fotografía',
      'Feria de Arte Local',
      'Maratón de la Ciudad',
      'Festival de Comida Callejera',
      'Conferencia de Tecnología',
      'Noche de Jazz en Vivo',
      'Mercado de Artesanías',
      'Clase de Yoga al Aire Libre',
      'Torneo de Fútbol Amateur',
      'Exposición de Arte Contemporáneo',
      'Festival de Cine Independiente',
      'Concierto Acústico',
      'Taller de Cocina Italiana',
      'Noche de Karaoke',
      'Festival de Danza Urbana',
      'Mercado de Productos Orgánicos',
      'Conferencia de Emprendimiento',
    ];

    final eventDescriptions = [
      'Una noche inolvidable con los mejores DJs del momento. Ven a disfrutar de la mejor música electrónica en un ambiente único.',
      'Disfruta de una noche llena de energía con las mejores bandas de rock alternativo. No te lo pierdas.',
      'Ríe hasta llorar con los mejores comediantes locales. Una noche de diversión garantizada.',
      'Aprende técnicas profesionales de fotografía con expertos en el campo. Trae tu cámara y prepárate para crear arte.',
      'Explora el talento local en esta increíble feria de arte. Pinturas, esculturas y mucho más.',
      'Únete a la comunidad en esta maratón anual. Corre, camina o anima a los participantes.',
      'Sabores únicos de todo el mundo en un solo lugar. La mejor comida callejera te espera.',
      'Conecta con innovadores y aprende sobre las últimas tendencias tecnológicas.',
      'Relájate con los sonidos suaves del jazz en un ambiente íntimo y acogedor.',
      'Descubre productos únicos hechos a mano por artesanos locales. Regalos perfectos y decoración original.',
      'Comienza tu día con energía positiva. Clase de yoga gratuita en el parque central.',
      'Apoya a los equipos locales en este emocionante torneo. ¡Ven a animar!',
      'Sumérgete en el mundo del arte contemporáneo con esta increíble exposición.',
      'Disfruta de películas independientes que no verás en ningún otro lugar.',
      'Una experiencia íntima con música acústica. Perfecto para una noche relajada.',
      'Aprende a preparar auténtica pasta italiana con chefs profesionales.',
      'Canta tus canciones favoritas en esta noche especial de karaoke. ¡Todos son bienvenidos!',
      'Mira a los mejores bailarines urbanos en acción. Un espectáculo lleno de energía.',
      'Productos frescos y orgánicos directamente de los productores locales.',
      'Inspírate con las historias de éxito de emprendedores locales. Aprende y conecta.',
    ];

    final cities = city != null && city.isNotEmpty
        ? [city]
        : ['Ciudad de México', 'Guadalajara', 'Monterrey', 'Puebla', 'Tijuana'];

    return List.generate(limit, (index) {
      final eventIndex = index % eventTitles.length;
      final startTime =
          now.add(Duration(days: index % 30 + 1, hours: (index % 12) + 10));
      final eventCity = cities[index % cities.length];

      return EventModel(
        id: 'demo-event-$index',
        title: eventTitles[eventIndex],
        description: eventDescriptions[eventIndex],
        startTime: startTime,
        endTime: startTime.add(Duration(hours: 2 + (index % 4))),
        city: eventCity,
        address: '${eventCity}, ${[
          "Av. Principal",
          "Plaza Central",
          "Centro Cultural",
          "Parque Central",
          "Teatro Municipal"
        ][index % 5]} ${index + 1}',
        status: 'published',
        isPublic: true,
        createdBy: 'demo-user-${index % 3}',
        createdAt: now.subtract(Duration(days: index % 7)),
        viewsCount: 50 + (index * 15) + (index % 100),
        interestedCount: 10 + (index * 3) + (index % 50),
      );
    });
  }

  // Obtener eventos públicos por ciudad
  Future<List<EventModel>> getPublicEventsByCity({
    String? city,
    int limit = 20,
    int offset = 0,
  }) async {
    // Si está en modo demo, retornar eventos mock
    if (isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final allEvents = _generateMockEvents(city: city, limit: limit + offset);
      return allEvents.skip(offset).take(limit).toList();
    }

    // Intentar obtener eventos de Supabase con timeout
    try {
      var query = _supabase!
          .from('events')
          .select()
          .eq('is_public', true)
          .eq('status', 'published');

      // Solo filtrar por ciudad si se proporciona y no está vacía
      if (city != null && city.trim().isNotEmpty) {
        query = query.eq('city', city.trim());
      }

      final response = await query
          .order('start_time', ascending: true)
          .range(offset, offset + limit - 1)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('La consulta tardó demasiado');
        },
      );

      final events =
          (response as List).map((json) => EventModel.fromJson(json)).toList();
      return events;
    } catch (e) {
      // Si falla Supabase, retornar eventos mock como fallback
      await Future.delayed(const Duration(milliseconds: 300));
      final allEvents = _generateMockEvents(city: city, limit: limit + offset);
      return allEvents.skip(offset).take(limit).toList();
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
          description:
              'Este es un evento de demostración detallado. Puedes explorar todas las características de la interfaz.',
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
      await _supabase!
          .rpc('increment_event_views', params: {'event_id': eventId});
    } catch (e) {
      // Ignorar errores al incrementar vistas
    }
  }
}
