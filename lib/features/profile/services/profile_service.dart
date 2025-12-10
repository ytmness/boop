import '../../../core/config/supabase_config.dart';
import '../../../shared/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  // Obtener perfil por user_id
  Future<UserModel?> getProfile(String userId) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final response = await _supabase!
          .from('profiles')
          .select(
              'user_id, name, avatar_url, bio, city, is_verified, created_at, updated_at')
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  // Obtener perfil del usuario actual
  Future<UserModel?> getCurrentProfile() async {
    if (_supabase == null) return null;
    final user = _supabase!.auth.currentUser;
    if (user == null) return null;

    try {
      return await getProfile(user.id);
    } catch (e) {
      return null;
    }
  }

  // Actualizar perfil
  Future<UserModel> updateProfile({
    String? name,
    String? avatarUrl,
    String? bio,
    String? city,
  }) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    final user = _supabase!.auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
      if (bio != null) updates['bio'] = bio;
      if (city != null) updates['city'] = city;

      final response = await _supabase!
          .from('profiles')
          .update(updates)
          .eq('user_id', user.id)
          .select(
              'user_id, name, avatar_url, bio, city, is_verified, created_at, updated_at')
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  // Crear perfil (si no existe)
  Future<UserModel> createProfile({
    required String userId,
    String? name,
    String? avatarUrl,
    String? bio,
    String? city,
  }) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final profileData = {
        'user_id': userId,
        if (name != null) 'name': name,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
        if (bio != null) 'bio': bio,
        if (city != null) 'city': city,
      };

      final response = await _supabase!
          .from('profiles')
          .insert(profileData)
          .select(
              'user_id, name, avatar_url, bio, city, is_verified, created_at, updated_at')
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('Error al crear perfil: $e');
    }
  }
}
