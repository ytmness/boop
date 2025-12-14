//
//  LoginView.swift
//  BoopApp
//
//  Login screen refactorizado con Liquid Glass REAL (sin overlays/gradientes)
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            // Fondo animado (sin glass, solo gradientes)
            GlassAnimatedBackground()
            
            // Contenido principal
            ScrollView {
                VStack(spacing: 24) { // Spacing.xxl equivalente
                    Spacer()
                        .frame(height: 60)
                    
                    // Logo/Icon - Material simple sin overlays
                    Circle()
                        .fill(.thinMaterial)
                        .frame(width: 140, height: 140)
                        .overlay {
                            Image(systemName: "sparkles")
                                .font(.system(size: 60))
                                .foregroundStyle(.white)
                        }
                    
                    Text("BOOP")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    // Login form - Material simple (NO glass para cards estáticas)
                    VStack(spacing: 16) { // Spacing.lg equivalente
                        // Email field
                        SimpleTextField(
                            "Email",
                            text: $viewModel.email,
                            icon: "envelope"
                        )
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        
                        // Password field
                        SimpleTextField(
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
                                .padding(.vertical, 4) // Spacing.xs equivalente
                        }
                        
                        // Login button - Glass real (botón flotante)
                        SimpleGlassButton("Iniciar Sesión") {
                            Task {
                                await viewModel.login()
                            }
                        }
                        .disabled(viewModel.isLoading)
                        .opacity(viewModel.isLoading ? 0.6 : 1.0)
                    
                        // Divider
                        HStack(spacing: 12) { // Spacing.md equivalente
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                            
                            Text("o")
                                .foregroundStyle(.white.opacity(0.5))
                                .padding(.horizontal, 12) // Spacing.md equivalente
                            
                            Rectangle()
                                .fill(.white.opacity(0.2))
                                .frame(height: 1)
                        }
                        .padding(.vertical, 8) // Spacing.sm equivalente
                        
                        // Alternative login options - Botones circulares con glass real
                        HStack(spacing: 16) { // Spacing.lg equivalente
                            SimpleGlassCircleButton(icon: "apple.logo", size: 56) {
                                Task {
                                    await viewModel.loginWithApple()
                                }
                            }
                            
                            SimpleGlassCircleButton(icon: "envelope.fill", size: 56) {
                                Task {
                                    await viewModel.loginWithEmail()
                                }
                            }
                        }
                    }
                    .padding(16) // CardSize.padding equivalente
                    .background {
                        RoundedRectangle(cornerRadius: 24) // CardSize.cornerRadiusLarge equivalente
                            .fill(.thinMaterial)
                    }
                    .padding(.horizontal, 24) // Spacing.xxl equivalente
                    
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
                    .padding(.top, 8) // Spacing.sm equivalente
                    
                    Spacer()
                        .frame(height: 40)
                }
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

// MARK: - Componentes auxiliares simplificados

private struct SimpleTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let isSecure: Bool
    @FocusState private var isFocused: Bool
    
    init(
        _ placeholder: String,
        text: Binding<String>,
        icon: String? = nil,
        isSecure: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
        self.isSecure = isSecure
    }
    
    var body: some View {
        HStack(spacing: 12) { // Spacing.md equivalente
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 20)
            }
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .foregroundStyle(.white)
                    .focused($isFocused)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(.plain)
                    .foregroundStyle(.white)
                    .focused($isFocused)
            }
        }
        .frame(height: 52) // InputSize.height equivalente
        .padding(.horizontal, 16) // InputSize.padding equivalente
        .background {
            RoundedRectangle(cornerRadius: 16) // InputSize.cornerRadius equivalente
                .fill(.thinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isFocused ? Color.white.opacity(0.3) : Color.white.opacity(0.1),
                    lineWidth: isFocused ? 1.5 : 1
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

private struct SimpleGlassButton: View {
    let title: String
    let action: () -> Void
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52) // ButtonSize.primaryHeight equivalente
                .padding(.horizontal, 24) // ButtonSize.primaryHorizontalPadding equivalente
        }
        .buttonStyle(SimpleGlassButtonStyle())
    }
}

private struct SimpleGlassButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                if reduceTransparency {
                    Capsule()
                        .fill(Color(white: 0.3))
                } else {
                    if #available(iOS 26.0, *) {
                        Capsule()
                            .fill(Color.clear)
                            .glassEffect(.clear.interactive())
                    } else {
                        Capsule()
                            .fill(.ultraThinMaterial)
                    }
                }
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

private struct SimpleGlassCircleButton: View {
    let icon: String
    let size: CGFloat
    let action: () -> Void
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
                .frame(width: size, height: size)
        }
        .background {
            if reduceTransparency {
                Circle()
                    .fill(Color(white: 0.3))
            } else {
                if #available(iOS 26.0, *) {
                    Circle()
                        .fill(Color.clear)
                        .glassEffect(.clear.interactive())
                } else {
                    Circle()
                        .fill(.ultraThinMaterial)
                }
            }
        }
        .clipShape(Circle())
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}

