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
    
    // Tamaños escalables
    @ScaledMetric(relativeTo: .largeTitle) private var logoSize: CGFloat = 140
    @ScaledMetric(relativeTo: .largeTitle) private var logoIconSize: CGFloat = 60
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize: CGFloat = 48
    @ScaledMetric(relativeTo: .body) private var spacing: CGFloat = 24
    @ScaledMetric(relativeTo: .body) private var topPadding: CGFloat = 60
    
    var body: some View {
        ZStack {
            GlassAnimatedBackground()
            
            ScrollView {
                VStack(spacing: spacing) {
                    Spacer()
                        .frame(height: topPadding)
                    
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
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    // ✅ CONTENEDOR MÁS COMPACTO Y ANGOSTO
                    VStack(spacing: spacing * 0.35) {
                        SimpleTextField(
                            "Email",
                            text: $emailInput,
                            icon: "envelope"
                        )
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.vertical, 4)
                        }
                        
                        SimpleGlassButton("Continuar con Email") {
                            sendOTP()
                        }
                        .disabled(viewModel.isLoading || emailInput.isEmpty)
                        .opacity((viewModel.isLoading || emailInput.isEmpty) ? 0.6 : 1.0)
                    }
                    .padding(spacing * 0.35)
                    .frame(maxWidth: 340) // ⬅️ MÁS PEQUEÑO
                    .background {
                        RoundedRectangle(cornerRadius: spacing * 0.6)
                            .fill(.thinMaterial)
                    }
                    .padding(.horizontal, spacing * 0.35)
                    
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
            if isAuth {
                showOTPView = false
            }
        }
    }
    
    private func sendOTP() {
        guard !emailInput.isEmpty, emailInput.contains("@") else {
            viewModel.errorMessage = "Por favor, ingresa un email válido"
            return
        }
        
        Task {
            try? await viewModel.sendOTP(email: emailInput)
            showOTPView = true
        }
    }
}

// MARK: - Componentes auxiliares

private struct SimpleTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let isSecure: Bool
    @FocusState private var isFocused: Bool
    
    @ScaledMetric(relativeTo: .body) private var fieldHeight: CGFloat = 44
    @ScaledMetric(relativeTo: .body) private var horizontalPadding: CGFloat = 14
    @ScaledMetric(relativeTo: .body) private var cornerRadius: CGFloat = 14
    @ScaledMetric(relativeTo: .body) private var iconWidth: CGFloat = 18
    @ScaledMetric(relativeTo: .body) private var spacing: CGFloat = 10
    
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
        .frame(minHeight: fieldHeight)
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
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: isFocused)
    }
}

private struct SimpleGlassButton: View {
    let title: String
    let action: () -> Void
    
    @ScaledMetric(relativeTo: .body) private var buttonHeight: CGFloat = 46
    @ScaledMetric(relativeTo: .body) private var horizontalPadding: CGFloat = 20
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: buttonHeight)
                .padding(.horizontal, horizontalPadding)
        }
        .buttonStyle(SimpleGlassButtonStyle())
    }
}

private struct SimpleGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                Capsule().fill(.ultraThinMaterial)
            }
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
