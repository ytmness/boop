import '../../../core/config/supabase_config.dart';
import '../../../shared/models/community_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunitiesService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  // Obtener comunidades por ciudad
  Future<List<CommunityModel>> getCommunitiesByCity({
    String? city,
    int limit = 20,
  }) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      var query = _supabase!
          .from('communities')
          .select();

      if (city != null && city.isNotEmpty) {
        query = query.eq('city', city);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);
      
      return (response as List)
          .map((json) => CommunityModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener comunidades: $e');
    }
  }

  // Obtener comunidad por ID
  Future<CommunityModel?> getCommunityById(String communityId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('communities')
          .select()
          .eq('id', communityId)
          .maybeSingle();

      if (response == null) return null;
      return CommunityModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener comunidad: $e');
    }
  }

  // Obtener comunidades que sigue el usuario
  Future<List<CommunityModel>> getUserFollowedCommunities(String userId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('community_followers')
          .select('communities(*)')
          .eq('user_id', userId);

      return (response as List)
          .map((item) => CommunityModel.fromJson(item['communities']))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener comunidades seguidas: $e');
    }
  }

  // Seguir comunidad
  Future<void> followCommunity(String communityId, String userId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!.from('community_followers').insert({
        'community_id': communityId,
        'user_id': userId,
      });
    } catch (e) {
      throw Exception('Error al seguir comunidad: $e');
    }
  }

  // Dejar de seguir comunidad
  Future<void> unfollowCommunity(String communityId, String userId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!
          .from('community_followers')
          .delete()
          .eq('community_id', communityId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Error al dejar de seguir comunidad: $e');
    }
  }

  // Crear comunidad
  Future<CommunityModel> createCommunity({
    required String name,
    String? description,
    String? city,
    String? logoUrl,
    required String ownerUserId,
  }) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('communities')
          .insert({
            'name': name,
            'description': description,
            'city': city,
            'logo_url': logoUrl,
            'owner_user_id': ownerUserId,
          })
          .select()
          .single();

      return CommunityModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear comunidad: $e');
    }
  }
}

