//
//  LoginView.swift
//  BoopApp
//
//  Login screen refactorizado con Liquid Glass REAL (sin overlays/gradientes)
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showOTPView = false
    @State private var emailInput = ""
    
    // Tamaños escalables que responden al Dynamic Type y Zoom
    @ScaledMetric(relativeTo: .largeTitle) private var logoSize: CGFloat = 140
    @ScaledMetric(relativeTo: .largeTitle) private var logoIconSize: CGFloat = 60
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 48
    @ScaledMetric(relativeTo: .body) private var spacing: CGFloat = 24
    @ScaledMetric(relativeTo: .body) private var topPadding: CGFloat = 60
    
    var body: some View {
        ZStack {
            // Fondo animado (sin glass, solo gradientes)
            GlassAnimatedBackground()
            
            // Contenido principal
            ScrollView {
                VStack(spacing: spacing) { // Spacing escalable
                    Spacer()
                        .frame(height: topPadding)
                    
                    // Logo/Icon - Material simple sin overlays - Escalable
                    Circle()
                        .fill(.thinMaterial)
                        .frame(width: logoSize, height: logoSize)
                        .overlay {
                            Image(systemName: "sparkles")
                                .font(.system(size: logoIconSize))
                                .foregroundStyle(.white)
                        }
                    
                    Text("BOOP")
                        .font(.system(size: titleSize, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5) // Permite reducir si es necesario
                        .lineLimit(1)
                    
                    // Login form - Material simple (NO glass para cards estáticas)
                    VStack(spacing: spacing * 0.67) { // Spacing.lg equivalente (16/24 = 0.67)
                        // Email field
                        SimpleTextField(
                            "Email",
                            text: $emailInput,
                            icon: "envelope"
                        )
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        
                        // Error message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.vertical, 4) // Spacing.xs equivalente
                        }
                        
                        // Login button - Glass real (botón flotante)
                        SimpleGlassButton("Continuar con Email") {
                            sendOTP()
                        }
                        .disabled(viewModel.isLoading || emailInput.isEmpty)
                        .opacity((viewModel.isLoading || emailInput.isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(spacing * 0.67) // CardSize.padding equivalente (16/24)
                    .background {
                        RoundedRectangle(cornerRadius: spacing) // CardSize.cornerRadiusLarge equivalente
                            .fill(.thinMaterial)
                    }
                    .padding(.horizontal, spacing) // Spacing.xxl equivalente
                    
                    Spacer()
                        .frame(height: 40)
                }
            }
        }
        .sheet(isPresented: $showOTPView) {
            VerifyOTPView(email: emailInput)
                .environmentObject(viewModel)
        }
        .onChange(of: viewModel.isAuthenticated) { _, isAuth in
            // Navegación automática al autenticarse
            if isAuth {
                showOTPView = false
                // ContentView manejará el cambio
            }
        }
    }
    
    private func sendOTP() {
        guard !emailInput.isEmpty, emailInput.contains("@") else {
            viewModel.errorMessage = "Por favor, ingresa un email válido"
            return
        }
        
        Task {
            do {
                try await viewModel.sendOTP(email: emailInput)
                showOTPView = true
            } catch {
                // Error manejado por viewModel.errorMessage
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
    
    // Tamaños responsivos
    @ScaledMetric(relativeTo: .body) private var fieldHeight: CGFloat = 52
    @ScaledMetric(relativeTo: .body) private var horizontalPadding: CGFloat = 16
    @ScaledMetric(relativeTo: .body) private var cornerRadius: CGFloat = 16
    @ScaledMetric(relativeTo: .body) private var iconWidth: CGFloat = 20
    @ScaledMetric(relativeTo: .body) private var spacing: CGFloat = 12
    
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
        HStack(spacing: spacing) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: iconWidth)
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
        .frame(minHeight: fieldHeight) // minHeight en vez de height fijo
        .padding(.horizontal, horizontalPadding)
        .background {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.thinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
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
    
    // Tamaños responsivos
    @ScaledMetric(relativeTo: .body) private var buttonHeight: CGFloat = 52
    @ScaledMetric(relativeTo: .body) private var horizontalPadding: CGFloat = 24
    
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
                .frame(minHeight: buttonHeight) // minHeight para responder a Dynamic Type
                .padding(.horizontal, horizontalPadding)
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
    let baseSize: CGFloat // Tamaño base antes de escalar
    let action: () -> Void
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    // Tamaño escalable
    @ScaledMetric private var size: CGFloat
    
    init(icon: String, size: CGFloat, action: @escaping () -> Void) {
        self.icon = icon
        self.baseSize = size
        self._size = ScaledMetric(wrappedValue: size, relativeTo: .body)
        self.action = action
    }
    
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

