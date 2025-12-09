import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static bool _initialized = false;
  
  static Future<void> initialize() async {
    if (_initialized) return;
    
    // TODO: Reemplazar con tus credenciales de Supabase
    const supabaseUrl = String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'YOUR_SUPABASE_URL',
    );
    const supabaseAnonKey = String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'YOUR_SUPABASE_ANON_KEY',
    );

    // Solo inicializar si las credenciales están configuradas
    if (supabaseUrl != 'YOUR_SUPABASE_URL' && supabaseAnonKey != 'YOUR_SUPABASE_ANON_KEY') {
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
        print('Error inicializando Supabase: $e');
        // Continuar sin Supabase para modo demo
      }
    } else {
      print('⚠️ Supabase no configurado - Modo demo activado');
    }
  }

  static SupabaseClient? get client {
    try {
      return Supabase.instance.client;
    } catch (e) {
      return null;
    }
  }
  
  static bool get isConfigured => _initialized;
}

