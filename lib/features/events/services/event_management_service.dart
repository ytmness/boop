import '../../../core/config/supabase_config.dart';
import '../../../shared/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventManagementService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  // Crear evento
  Future<EventModel> createEvent({
    required String title,
    String? description,
    required DateTime startTime,
    DateTime? endTime,
    String? timezone,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    String? imageUrl,
    String? communityId,
    required String createdBy,
    bool isPublic = false,
  }) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('events')
          .insert({
            'title': title,
            'description': description,
            'start_time': startTime.toIso8601String(),
            'end_time': endTime?.toIso8601String(),
            'timezone': timezone,
            'city': city,
            'address': address,
            'lat': latitude,
            'lng': longitude,
            'image_url': imageUrl,
            'community_id': communityId,
            'created_by': createdBy,
            'is_public': isPublic,
            'status': isPublic ? 'published' : 'draft',
          })
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear evento: $e');
    }
  }

  // Actualizar evento
  Future<EventModel> updateEvent({
    required String eventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? city,
    String? address,
    double? latitude,
    double? longitude,
    String? imageUrl,
    bool? isPublic,
  }) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (startTime != null) updates['start_time'] = startTime.toIso8601String();
      if (endTime != null) updates['end_time'] = endTime.toIso8601String();
      if (city != null) updates['city'] = city;
      if (address != null) updates['address'] = address;
      if (latitude != null) updates['lat'] = latitude;
      if (longitude != null) updates['lng'] = longitude;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      if (isPublic != null) updates['is_public'] = isPublic;

      final response = await _supabase!
          .from('events')
          .update(updates)
          .eq('id', eventId)
          .select()
          .single();

      return EventModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar evento: $e');
    }
  }

  // Obtener estadísticas del evento
  Future<Map<String, dynamic>> getEventStats(String eventId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      // Obtener conteo de tickets vendidos
      final ticketsResponse = await _supabase!
          .from('tickets')
          .select('id')
          .eq('event_id', eventId);

      final ticketsSold = (ticketsResponse as List).length;

      // Obtener ingresos totales
      final ordersResponse = await _supabase!
          .from('orders')
          .select('amount')
          .eq('event_id', eventId)
          .eq('payment_status', 'paid');

      double totalRevenue = 0;
      for (var order in ordersResponse as List) {
        totalRevenue += (order['amount'] as num).toDouble();
      }

      // Obtener vistas
      final eventResponse = await _supabase!
          .from('events')
          .select('views_count')
          .eq('id', eventId)
          .single();

      return {
        'tickets_sold': ticketsSold,
        'total_revenue': totalRevenue,
        'views': eventResponse['views_count'] ?? 0,
      };
    } catch (e) {
      throw Exception('Error al obtener estadísticas: $e');
    }
  }
}

