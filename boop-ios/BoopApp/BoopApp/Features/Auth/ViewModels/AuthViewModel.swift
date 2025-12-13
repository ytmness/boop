//
//  AuthViewModel.swift
//  BoopApp
//
//  ViewModel para autenticación (MVVM)
//

import SwiftUI
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Login
    
    func login() async {
        isLoading = true
        errorMessage = nil
        
        // Validación básica
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Por favor completa todos los campos"
            isLoading = false
            return
        }
        
        guard email.contains("@") else {
            errorMessage = "Email inválido"
            isLoading = false
            return
        }
        
        // Simular login (aquí irá la integración con Supabase)
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        
        // Éxito (por ahora simulado)
        isAuthenticated = true
        isLoading = false
    }
    
    // MARK: - Logout
    
    func logout() {
        isAuthenticated = false
        email = ""
        password = ""
    }
    
    // MARK: - Social Login
    
    func loginWithApple() async {
        isLoading = true
        // Implementar Sign in with Apple
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isAuthenticated = true
        isLoading = false
    }
    
    func loginWithEmail() async {
        isLoading = true
        // Implementar magic link
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
    }
}

