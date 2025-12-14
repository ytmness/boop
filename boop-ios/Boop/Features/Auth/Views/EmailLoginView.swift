import SwiftUI

/// Pantalla de Login con Email - Mismo flujo que Flutter
struct EmailLoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var email = ""
    @State private var codeSent = false
    @FocusState private var isEmailFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    GlassBackButton {
                        dismiss()
                    }
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.lg) {  // ✅ Reducido spacing
                        // Título
                        VStack(alignment: .leading, spacing: Spacing.xs) {  // ✅ Reducido spacing
                            Text(codeSent ? "Revisa tu correo" : "Ingresa tu correo electrónico")
                                .font(.system(size: 20, weight: .bold))  // ✅ Reducido de 24 a 20
                                .foregroundStyle(.white)
                            
                            if codeSent {
                                Text("Te hemos enviado un código de verificación a \(email)\n\nBusca el código numérico de 6 dígitos en tu correo.")
                                    .font(.system(size: 14))  // ✅ Reducido de 16 a 14
                                    .foregroundStyle(.white.opacity(0.8))
                            } else {
                                Text("Te enviaremos un código de verificación")
                                    .font(.system(size: 14))  // ✅ Reducido de 16 a 14
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .padding(.horizontal, Spacing.lg)
                        
                        if !codeSent {
                            // Campo de email
                            GlassTextField(
                                placeholder: "correo@ejemplo.com",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            .focused($isEmailFocused)
                            .padding(.horizontal, Spacing.lg)
                        }
                        
                        Spacer()
                        
                        // Botones
                        VStack(spacing: Spacing.lg) {
                            if codeSent {
                                NavigationLink {
                                    VerifyOTPView(phoneOrEmail: email, isEmail: true)
                                } label: {
                                    GlassButton(
                                        title: "Verificar código",
                                        action: {}
                                    )
                                }
                                
                                Button("Cambiar correo") {
                                    codeSent = false
                                }
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                            } else {
                                GlassButton(
                                    title: "Enviar código",
                                    action: sendCode,
                                    isLoading: viewModel.isLoading
                                )
                            }
                            
                            Button("¿Necesitas ayuda?") {
                                // Navegar a soporte
                            }
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                        }
                        .padding(.horizontal, Spacing.lg)
                        .padding(.bottom, Spacing.lg)
                    }
                    .padding(.top, Spacing.xl)
                }
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.errorMessage = nil
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
    }
    
    private func sendCode() {
        guard !email.isEmpty, email.contains("@") else {
            viewModel.errorMessage = "Correo electrónico inválido"
            return
        }
        
        Task {
            do {
                try await viewModel.signInWithEmail(email)
                codeSent = true
            } catch {
                // Error manejado por viewModel.errorMessage
            }
        }
    }
}

#Preview {
    NavigationStack {
        EmailLoginView()
    }
}

