import SwiftUI

/// Pantalla de Login con Teléfono - Mismo flujo que Flutter
struct PhoneLoginView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var phoneNumber = ""
    @State private var countryCode = "+1"
    @FocusState private var isPhoneFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Fondo con blur (similar a BlurredVideoBackground)
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header con botón atrás
                HStack {
                    GlassBackButton {
                        dismiss()
                    }
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Título
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Iniciar sesión")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("Ingresa tu número de teléfono")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("Te enviaremos un código de verificación")
                                .font(.system(size: 16))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        
                        // Campo de teléfono
                        HStack(spacing: 12) {
                            GlassContainer(cornerRadius: 16, padding: 0) {
                                Text(countryCode)
                                    .foregroundStyle(.white)
                                    .frame(width: 80)
                                    .multilineTextAlignment(.center)
                            }
                            
                            GlassTextField(
                                placeholder: "Número de teléfono",
                                text: $phoneNumber,
                                keyboardType: .phonePad
                            )
                            .focused($isPhoneFocused)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Botón enviar
                        VStack(spacing: 16) {
                            NavigationLink {
                                VerifyOTPView(phoneOrEmail: "\(countryCode)\(phoneNumber)", isEmail: false)
                            } label: {
                                GlassButton(
                                    title: "Enviar código",
                                    action: sendOTP,
                                    isLoading: viewModel.isLoading
                                )
                            }
                            .disabled(viewModel.isLoading || phoneNumber.isEmpty)
                            .padding(.horizontal)
                            
                            Button("¿Problemas con el código?") {
                                // Navegar a soporte
                            }
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                        }
                        .padding(.bottom)
                    }
                    .padding(.top, 40)
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
    
    private func sendOTP() {
        guard !phoneNumber.isEmpty, phoneNumber.count >= 10 else {
            viewModel.errorMessage = "Número de teléfono inválido"
            return
        }
        
        let fullPhone = "\(countryCode)\(phoneNumber)"
        
        Task {
            do {
                try await viewModel.signInWithPhone(fullPhone)
                // La navegación se maneja con NavigationLink
            } catch {
                // Error manejado por viewModel.errorMessage
            }
        }
    }
}

#Preview {
    PhoneLoginView()
}

