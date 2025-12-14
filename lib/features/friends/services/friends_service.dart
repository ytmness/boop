import '../../../core/config/supabase_config.dart';
import '../../../shared/models/friend_model.dart';
import '../../../shared/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendsService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  // Obtener lista de amigos
  Future<List<UserModel>> getFriends(String userId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('friends')
          .select('profiles!friends_friend_user_id_fkey(*)')
          .eq('user_id', userId)
          .eq('status', 'accepted');

      return (response as List)
          .map((item) => UserModel.fromJson(item['profiles']))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener amigos: $e');
    }
  }

  // Obtener solicitudes pendientes
  Future<List<FriendModel>> getPendingRequests(String userId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('friends')
          .select()
          .eq('friend_user_id', userId)
          .eq('status', 'pending');

      return (response as List)
          .map((json) => FriendModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener solicitudes: $e');
    }
  }

  // Enviar solicitud de amistad
  Future<void> sendFriendRequest(String userId, String friendUserId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!.from('friends').insert({
        'user_id': userId,
        'friend_user_id': friendUserId,
        'status': 'pending',
      });
    } catch (e) {
      throw Exception('Error al enviar solicitud: $e');
    }
  }

  // Aceptar solicitud de amistad
  Future<void> acceptFriendRequest(String requestId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!
          .from('friends')
          .update({'status': 'accepted'})
          .eq('id', requestId);
    } catch (e) {
      throw Exception('Error al aceptar solicitud: $e');
    }
  }

  // Rechazar solicitud de amistad
  Future<void> rejectFriendRequest(String requestId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!.from('friends').delete().eq('id', requestId);
    } catch (e) {
      throw Exception('Error al rechazar solicitud: $e');
    }
  }

  // Eliminar amigo
  Future<void> removeFriend(String userId, String friendUserId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!
          .from('friends')
          .delete()
          .eq('user_id', userId)
          .eq('friend_user_id', friendUserId);
    } catch (e) {
      throw Exception('Error al eliminar amigo: $e');
    }
  }
}

