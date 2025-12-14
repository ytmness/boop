import Foundation
import Supabase

/// Configuración de Supabase - Mismas credenciales que Flutter
class SupabaseConfig {
    static let shared = SupabaseConfig()
    
    // Mismas credenciales del proyecto Flutter
    private let supabaseURL = "https://wmhithphfqvyfzeerazg.supabase.co"
    private let supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtaGl0aHBoZnF2eWZ6ZWVyYXpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjUzMzE3NzUsImV4cCI6MjA4MDkwNzc3NX0.MMCefqPe4kMiE3gUHPKH9d50UP1ZW0dVjFo_fyWag40"
    
    private(set) var client: SupabaseClient?
    
    private init() {
        initialize()
    }
    
    func initialize() {
        client = SupabaseClient(
            supabaseURL: URL(string: supabaseURL)!,
            supabaseKey: supabaseAnonKey
        )
    }
}

