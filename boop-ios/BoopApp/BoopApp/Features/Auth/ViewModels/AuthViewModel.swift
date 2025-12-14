//
//  AuthViewModel.swift
//  BoopApp
//
//  ViewModel para autenticación con OTP de email (6 dígitos)
//

import SwiftUI
import Combine
import Supabase

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var otpCode: String = ""
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var currentUser: User?
    
    private var supabaseClient: SupabaseClient? {
        SupabaseConfig.shared.client
    }
    
    private let sessionKey = "supabase_session"
    
    init() {
        checkAuthState()
    }
    
    // MARK: - Verificar Estado de Autenticación
    
    func checkAuthState() {
        guard let supabase = supabaseClient else {
            isAuthenticated = false
            return
        }
        
        Task {
            do {
                let session = try await supabase.auth.session
                if let user = session.user {
                    await MainActor.run {
                        self.currentUser = user
                        self.isAuthenticated = true
                    }
                } else {
                    await MainActor.run {
                        self.isAuthenticated = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    // MARK: - Enviar OTP por Email
    
    func sendOTP(email: String) async throws {
        guard let supabase = supabaseClient else {
            throw AuthError.supabaseNotConfigured
        }
        
        // Validar email
        guard !email.isEmpty, email.contains("@") else {
            throw AuthError.invalidEmail
        }
        
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
            self.email = email
        }
        
        defer {
            Task { @MainActor in
                self.isLoading = false
            }
        }
        
        do {
            try await supabase.auth.signInWithOTP(
                email: email,
                shouldCreateUser: true
            )
        } catch {
            let userFriendlyError = mapErrorToUserMessage(error)
            await MainActor.run {
                self.errorMessage = userFriendlyError
            }
            throw error
        }
    }
    
    // MARK: - Verificar OTP (6 dígitos)
    
    func verifyOTP(email: String, token: String) async throws {
        guard let supabase = supabaseClient else {
            throw AuthError.supabaseNotConfigured
        }
        
        // Validar que el token tenga 6 dígitos
        let cleanToken = token.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        guard cleanToken.count == 6 else {
            let error = AuthError.invalidOTP
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            throw error
        }
        
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        defer {
            Task { @MainActor in
                self.isLoading = false
            }
        }
        
        do {
            let response = try await supabase.auth.verifyOTP(
                email: email,
                token: cleanToken,
                type: .email
            )
            
            guard let user = response.user else {
                throw AuthError.authenticationFailed
            }
            
            // Guardar sesión
            await saveSession(response.session)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.otpCode = ""
            }
            
            // Bootstrap del perfil
            await bootstrapProfile(userId: user.id)
            
        } catch {
            let userFriendlyError = mapErrorToUserMessage(error)
            await MainActor.run {
                self.errorMessage = userFriendlyError
            }
            throw error
        }
    }
    
    // MARK: - Bootstrap de Perfil
    
    private func bootstrapProfile(userId: UUID) async {
        guard let supabase = supabaseClient else { return }
        
        do {
            // Verificar si el perfil ya existe
            let existingProfiles: [ProfileRow] = try await supabase
                .from("profiles")
                .select()
                .eq("user_id", value: userId.uuidString)
                .execute()
                .value
            
            if existingProfiles.isEmpty {
                // Crear perfil nuevo con valores por defecto
                let defaultName = currentUser?.email?.components(separatedBy: "@").first ?? "Usuario"
                
                let newProfile: [String: Any] = [
                    "user_id": userId.uuidString,
                    "name": defaultName,
                    "is_verified": false
                ]
                
                try await supabase
                    .from("profiles")
                    .insert(newProfile)
                    .execute()
            }
        } catch {
            // Log error pero no bloquear el flujo de autenticación
            print("⚠️ Error al crear perfil: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Guardar Sesión
    
    private func saveSession(_ session: Session) async {
        // La sesión se guarda automáticamente por Supabase
        // Solo necesitamos verificar que esté disponible
        do {
            if let data = try? JSONEncoder().encode(session) {
                UserDefaults.standard.set(data, forKey: sessionKey)
            }
        } catch {
            print("⚠️ Error al guardar sesión: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Cerrar Sesión
    
    func logout() async {
        guard let supabase = supabaseClient else {
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
            }
            return
        }
        
        do {
            try await supabase.auth.signOut()
            
            // Limpiar sesión local
            UserDefaults.standard.removeObject(forKey: sessionKey)
            
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
                self.email = ""
                self.otpCode = ""
                self.errorMessage = nil
            }
        } catch {
            // Aún así, limpiar el estado local
            UserDefaults.standard.removeObject(forKey: sessionKey)
            
            await MainActor.run {
                self.isAuthenticated = false
                self.currentUser = nil
                self.email = ""
                self.otpCode = ""
            }
            
            print("⚠️ Error al cerrar sesión: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Mapeo de Errores a Mensajes Amigables
    
    private func mapErrorToUserMessage(_ error: Error) -> String {
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("invalid") && errorDescription.contains("token") {
            return "Código de verificación inválido. Por favor, verifica el código de 6 dígitos."
        }
        
        if errorDescription.contains("expired") {
            return "El código de verificación ha expirado. Por favor, solicita uno nuevo."
        }
        
        if errorDescription.contains("network") || errorDescription.contains("connection") {
            return "Error de conexión. Por favor, verifica tu internet e intenta de nuevo."
        }
        
        if errorDescription.contains("email") && errorDescription.contains("invalid") {
            return "Email inválido. Por favor, verifica tu dirección de correo."
        }
        
        if errorDescription.contains("rate limit") || errorDescription.contains("too many") {
            return "Demasiados intentos. Por favor, espera unos minutos antes de intentar de nuevo."
        }
        
        // Mensaje genérico
        return "Ocurrió un error. Por favor, intenta de nuevo."
    }
}


// MARK: - Modelo de Perfil

struct ProfileRow: Codable {
    let user_id: String
    let name: String?
    let avatar_url: String?
    let bio: String?
    let city: String?
    let is_verified: Bool?
    let created_at: String?
    let updated_at: String?
}

// MARK: - Errores de Autenticación

enum AuthError: LocalizedError {
    case supabaseNotConfigured
    case invalidEmail
    case invalidOTP
    case authenticationFailed
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .supabaseNotConfigured:
            return "La aplicación no está configurada correctamente. Por favor, contacta al soporte."
        case .invalidEmail:
            return "Email inválido. Por favor, verifica tu dirección de correo."
        case .invalidOTP:
            return "El código debe tener 6 dígitos. Por favor, verifica el código."
        case .authenticationFailed:
            return "Error al autenticarse. Por favor, intenta de nuevo."
        case .networkError:
            return "Error de conexión. Por favor, verifica tu internet."
        }
    }
}
