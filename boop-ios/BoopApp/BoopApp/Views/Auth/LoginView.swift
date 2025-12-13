//
//  LoginView.swift
//  BoopApp
//
//  Login screen with TRUE Liquid Glass effect
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @Namespace private var glassNamespace
    
    var body: some View {
        ZStack {
            // Fondo animado con orbes de luz
            GlassAnimatedBackground()
            
            // Contenido principal
            ScrollView {
                    VStack(spacing: 30) {
                        Spacer()
                            .frame(height: 60)
                        
                        // Logo/Icon with glass effect
                        ZStack {
                            Circle()
                                .fill(.ultraThinMaterial)
                                .overlay {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.2),
                                                    Color.blue.opacity(0.1),
                                                    Color.purple.opacity(0.15)
                                                ],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                }
                                .overlay {
                                    Circle()
                                        .strokeBorder(
                                            LinearGradient(
                                                colors: [
                                                    Color.white.opacity(0.6),
                                                    Color.blue.opacity(0.4)
                                                ],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            ),
                                            lineWidth: 2
                                        )
                                }
                                .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                                .shadow(color: .white.opacity(0.2), radius: 10, x: 0, y: -5)
                            
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, .blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        }
                        .frame(width: 140, height: 140)
                        
                        Text("BOOP")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                        
                        // Login form in glass card
                        GlassCard(cornerRadius: 28) {
                            VStack(spacing: 20) {
                                // Email field
                                GlassTextField(
                                    "Email",
                                    text: $viewModel.email,
                                    icon: "envelope"
                                )
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                
                                // Password field
                                GlassTextField(
                                    "Contraseña",
                                    text: $viewModel.password,
                                    icon: "lock",
                                    isSecure: true
                                )
                                .textContentType(.password)
                                
                                // Error message
                                if let error = viewModel.errorMessage {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundStyle(.red)
                                        .padding(.vertical, 4)
                                }
                                
                                // Login button
                                GlassButton("Iniciar Sesión", style: .prominent) {
                                    Task {
                                        await viewModel.login()
                                    }
                                }
                                .disabled(viewModel.isLoading)
                                .opacity(viewModel.isLoading ? 0.6 : 1.0)
                            
                                // Divider
                                HStack {
                                    Rectangle()
                                        .fill(.white.opacity(0.2))
                                        .frame(height: 1)
                                    
                                    Text("o")
                                        .foregroundStyle(.white.opacity(0.5))
                                        .padding(.horizontal, 12)
                                    
                                    Rectangle()
                                        .fill(.white.opacity(0.2))
                                        .frame(height: 1)
                                }
                                .padding(.vertical, 8)
                                
                                // Alternative login options
                                HStack(spacing: 16) {
                                    Button(action: {
                                        Task {
                                            await viewModel.loginWithApple()
                                        }
                                    }) {
                                        Image(systemName: "apple.logo")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                            .frame(width: 56, height: 56)
                                            .background {
                                                ZStack {
                                                    Circle()
                                                        .fill(.ultraThinMaterial)
                                                    Circle()
                                                        .fill(Color.white.opacity(0.1))
                                                    Circle()
                                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                                                }
                                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                            }
                                    }
                                    
                                    Button(action: {
                                        Task {
                                            await viewModel.loginWithEmail()
                                        }
                                    }) {
                                        Image(systemName: "envelope.fill")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                            .frame(width: 56, height: 56)
                                            .background {
                                                ZStack {
                                                    Circle()
                                                        .fill(.ultraThinMaterial)
                                                    Circle()
                                                        .fill(Color.white.opacity(0.1))
                                                    Circle()
                                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                                                }
                                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                                            }
                                    }
                                }
                            }
                        }
                        
                        // Sign up link
                        Button(action: {}) {
                            HStack(spacing: 4) {
                                Text("¿No tienes cuenta?")
                                    .foregroundStyle(.white.opacity(0.7))
                                Text("Regístrate")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.white)
                            }
                            .font(.subheadline)
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.horizontal, 24)
                }
        }
        .onChange(of: viewModel.isAuthenticated) { _, isAuth in
            // Navegación automática al autenticarse
            if isAuth {
                // ContentView manejará el cambio
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

