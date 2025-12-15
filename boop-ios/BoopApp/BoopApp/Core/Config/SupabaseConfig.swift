import Foundation
import Supabase

/// Configuración de Supabase - Singleton para asegurar un único cliente con sesión persistente
/// 
/// IMPORTANTE: Todos los componentes (AuthViewModel, EventsRepository, etc.) deben usar
/// este mismo singleton para compartir la misma sesión de autenticación.
/// 
/// El SDK de Supabase para Swift persiste automáticamente la sesión en el Keychain de iOS.
class SupabaseConfig {
    static let shared = SupabaseConfig()
    
    // Mismas credenciales del proyecto Flutter
    private let supabaseURL = "https://wmhithphfqvyfzeerazg.supabase.co"
    private let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtaGl0aHBoZnF2eWZ6ZWVyYXpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzE3NzUsImV4cCI6MjA4MDkwNzc3NX0.MMCefqPe4kMiE3gUHPKH9d50UP1ZW0dVjFo_fyWag40"
    
    /// Cliente único de Supabase - Se crea una sola vez y se reutiliza en toda la app
    /// La sesión se persiste automáticamente en el Keychain de iOS
    private(set) var client: SupabaseClient?
    
    private init() {
        initialize()
    }
    
    func initialize() {
        guard let url = URL(string: supabaseURL) else {
            print("⚠️ Error: URL de Supabase inválida")
            return
        }
        
        let authOptions = SupabaseClientOptions.AuthOptions(
            flowType: .pkce
        )
        
        client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: supabaseAnonKey,
            options: SupabaseClientOptions(
                auth: authOptions
            )
        )
        
        print("✅ SupabaseConfig inicializado correctamente (SDK actual)")
    }
}

