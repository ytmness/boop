// Comentado temporalmente - Firebase Messaging tiene problemas de compatibilidad con web
// import 'package:firebase_messaging/firebase_messaging.dart';
import '../config/supabase_config.dart';

class NotificationService {
  // final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final supabase = SupabaseConfig.client;

  // Solicitar permisos y registrar token
  Future<void> initialize() async {
    // TODO: Implementar cuando Firebase Messaging sea compatible con web
    // final settings = await _messaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   final token = await _messaging.getToken();
    //   if (token != null) {
    //     await _saveToken(token);
    //   }

    //   // Escuchar cambios en el token
    //   _messaging.onTokenRefresh.listen((newToken) {
    //     _saveToken(newToken);
    //   });
    // }
  }

  Future<void> _saveToken(String token) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from('user_devices').upsert({
        'user_id': user.id,
        'device_token': token,
        'platform': 'ios', // TODO: Detectar plataforma real
      });
    } catch (e) {
      // Ignorar errores al guardar token
    }
  }
}

