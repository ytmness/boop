import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    // Configuración de Supabase
    // Puedes usar variables de entorno o valores directos
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://wmhithphfqvyfzeerazg.supabase.co',
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtaGl0aHBoZnF2eWZ6ZWVyYXpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzE3NzUsImV4cCI6MjA4MDkwNzc3NX0.MMCefqPe4kMiE3gUHPKH9d50UP1ZW0dVjFo_fyWag40',
    );

    // Solo inicializar si las credenciales están configuradas
    if (supabaseUrl != 'YOUR_SUPABASE_URL' &&
        supabaseUrl != 'https://TU_PROYECTO.supabase.co' &&
        supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY') {
      try {
        await Supabase.initialize(
          url: supabaseUrl,
          anonKey: supabaseAnonKey,
          authOptions: const FlutterAuthClientOptions(
            authFlowType: AuthFlowType.pkce,
          ),
        );
        _initialized = true;
      } catch (e) {
        // Continuar sin Supabase para modo demo
      }
    } else {}
  }

  static SupabaseClient? get client {
    if (!_initialized) {
      return null;
    }
    try {
      return Supabase.instance.client;
    } catch (e) {
      return null;
    }
  }

  static bool get isConfigured => _initialized;
}
