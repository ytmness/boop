import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/config/supabase_config.dart';
import 'package:path/path.dart' as path;

class StorageService {
  SupabaseClient? get _supabase => SupabaseConfig.client;

  // Subir avatar de usuario
  Future<String> uploadAvatar(String userId, File imageFile) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final filePath = '$userId/$fileName';

      await _supabase!.storage.from('avatars').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true,
        ),
      );

      final url = _supabase!.storage.from('avatars').getPublicUrl(filePath);
      return url;
    } catch (e) {
      throw Exception('Error al subir avatar: $e');
    }
  }

  // Subir imagen de evento
  Future<String> uploadEventImage(String eventId, File imageFile) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final filePath = '$eventId/$fileName';

      await _supabase!.storage.from('event-images').upload(
        filePath,
        imageFile,
        fileOptions: const FileOptions(
          upsert: true,
        ),
      );

      final url = _supabase!.storage.from('event-images').getPublicUrl(filePath);
      return url;
    } catch (e) {
      throw Exception('Error al subir imagen de evento: $e');
    }
  }

  // Subir memory (foto de evento)
  Future<String> uploadMemory(String userId, String eventId, File imageFile) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final filePath = '$userId/$eventId/$fileName';

      await _supabase!.storage.from('memories').upload(
        filePath,
        imageFile,
      );

      final url = _supabase!.storage.from('memories').getPublicUrl(filePath);
      return url;
    } catch (e) {
      throw Exception('Error al subir memory: $e');
    }
  }

  // Eliminar archivo
  Future<void> deleteFile(String bucket, String filePath) async {
    if (_supabase == null) {
      throw Exception('Supabase no está configurado');
    }
    try {
      await _supabase!.storage.from(bucket).remove([filePath]);
    } catch (e) {
      throw Exception('Error al eliminar archivo: $e');
    }
  }
}

