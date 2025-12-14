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
                    VStack(alignment: .leading, spacing: Spacing.md) {  // ✅ Reducido spacing de lg a md
                        // Título
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text(codeSent ? "Revisa tu correo" : "Ingresa tu correo electrónico")
                                .font(.system(size: 18, weight: .bold))  // ✅ Reducido de 20 a 18
                                .foregroundStyle(.white)
                            
                            if codeSent {
                                Text("Te hemos enviado un código de verificación a \(email)\n\nBusca el código numérico de 6 dígitos en tu correo.")
                                    .font(.system(size: 13))  // ✅ Reducido de 14 a 13
                                    .foregroundStyle(.white.opacity(0.8))
                            } else {
                                Text("Te enviaremos un código de verificación")
                                    .font(.system(size: 13))  // ✅ Reducido de 14 a 13
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                        }
                        .padding(.horizontal, Spacing.md)  // ✅ Reducido padding horizontal de xl a md
                        
                        if !codeSent {
                            // Campo de email
                            GlassTextField(
                                placeholder: "correo@ejemplo.com",
                                text: $email,
                                keyboardType: .emailAddress
                            )
                            .focused($isEmailFocused)
                            .padding(.horizontal, Spacing.md)  // ✅ Reducido padding horizontal de xl a md
                        }
                        
                        Spacer()
                        
                        // Botones
                        VStack(spacing: Spacing.md) {  // ✅ Reducido spacing de lg a md
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
                                .font(.system(size: 13))  // ✅ Reducido de 14 a 13
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
                            .font(.system(size: 13))  // ✅ Reducido de 14 a 13
                        }
                        .padding(.horizontal, Spacing.md)  // ✅ Reducido padding horizontal de xl a md
                        .padding(.bottom, Spacing.md)  // ✅ Reducido de lg a md
                    }
                    .frame(maxWidth: 320)  // ✅ Reducido ancho máximo de 500 a 320
                    .frame(maxWidth: .infinity, alignment: .center)  // Centrar en pantallas grandes
                    .padding(.top, Spacing.md)  // ✅ Reducido padding top de xl a md
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

