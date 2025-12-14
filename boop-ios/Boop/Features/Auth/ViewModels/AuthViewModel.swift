import Foundation
import Supabase
import SwiftUI

/// ViewModel de Autenticación - Flujo OTP idéntico a Flutter
@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    private let supabase = SupabaseConfig.shared.client
    
    init() {
        checkAuthState()
    }
    
    // MARK: - Estado de Autenticación
    func checkAuthState() {
        guard let supabase = supabase else { return }
        
        Task {
            do {
                let session = try await supabase.auth.session
                await MainActor.run {
                    self.currentUser = session.user
                    self.isAuthenticated = session.user != nil
                }
            } catch {
                await MainActor.run {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    // MARK: - Enviar OTP por Teléfono
    func signInWithPhone(_ phone: String) async throws {
        guard let supabase = supabase else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            try await supabase.auth.signInWithOTP(
                phone: phone,
                shouldCreateUser: true
            )
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    // MARK: - Enviar OTP por Email
    func signInWithEmail(_ email: String) async throws {
        guard let supabase = supabase else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            try await supabase.auth.signInWithOTP(
                email: email,
                shouldCreateUser: true
            )
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    // MARK: - Verificar OTP (8 dígitos, igual que Flutter)
    func verifyOTP(phone: String, token: String) async throws {
        guard let supabase = supabase else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            let response = try await supabase.auth.verifyOTP(
                phone: phone,
                token: token,
                type: .sms
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
            }
            
            // Crear perfil si no existe
            await createProfileIfNeeded(user: response.user)
            
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    // MARK: - Verificar OTP por Email
    func verifyEmailOTP(email: String, token: String) async throws {
        guard let supabase = supabase else {
            throw AuthError.supabaseNotConfigured
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
        do {
            // Limpiar token (solo números)
            let cleanToken = token.trimmingCharacters(in: .whitespaces)
                .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
            
            let response = try await supabase.auth.verifyOTP(
                email: email,
                token: cleanToken,
                type: .email
            )
            
            await MainActor.run {
                self.currentUser = response.user
                self.isAuthenticated = true
            }
            
            // Crear perfil si no existe
            await createProfileIfNeeded(user: response.user)
            
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    // MARK: - Crear Perfil
    private func createProfileIfNeeded(user: User) async {
        guard let supabase = supabase else { return }
        
        do {
            // Verificar si el perfil ya existe
            let existingProfile: [UserProfile] = try await supabase
                .from("profiles")
                .select()
                .eq("user_id", value: user.id.uuidString)
                .execute()
                .value
            
            if existingProfile.isEmpty {
                // Crear perfil nuevo
                let formatter = ISO8601DateFormatter()
                let newProfile: [String: Any] = [
                    "user_id": user.id.uuidString,
                    "display_name": user.email ?? user.phone ?? "Usuario",
                    "created_at": formatter.string(from: Date())
                ]
                
                try await supabase
                    .from("profiles")
                    .insert(newProfile)
                    .execute()
            }
        } catch {
            print("Error al crear perfil: \(error)")
        }
    }
    
    // MARK: - Cerrar Sesión
    func signOut() async throws {
        guard let supabase = supabase else {
            throw AuthError.supabaseNotConfigured
        }
        
        try await supabase.auth.signOut()
        
        await MainActor.run {
            self.currentUser = nil
            self.isAuthenticated = false
        }
    }
}

// MARK: - Errores
enum AuthError: LocalizedError {
    case supabaseNotConfigured
    case invalidOTP
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .supabaseNotConfigured:
            return "Supabase no está configurado"
        case .invalidOTP:
            return "Código de verificación inválido"
        case .networkError:
            return "Error de conexión"
        }
    }
}

