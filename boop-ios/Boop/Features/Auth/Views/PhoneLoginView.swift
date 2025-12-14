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
                    VStack(alignment: .leading, spacing: Spacing.md) {  // ✅ Reducido spacing de lg a md
                        // Título
                        VStack(alignment: .leading, spacing: Spacing.xs) {
                            Text("Iniciar sesión")
                                .font(.system(size: 18, weight: .bold))  // ✅ Reducido de 20 a 18
                                .foregroundStyle(.white)
                            
                            Text("Ingresa tu número de teléfono")
                                .font(.system(size: 14, weight: .semibold))  // ✅ Reducido de 16 a 14
                                .foregroundStyle(.white)
                            
                            Text("Te enviaremos un código de verificación")
                                .font(.system(size: 13))  // ✅ Reducido de 14 a 13
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.horizontal, Spacing.md)  // ✅ Reducido padding horizontal de xl a md
                        
                        // Campo de teléfono
                        HStack(spacing: Spacing.sm) {  // ✅ Reducido spacing de md a sm
                            GlassContainer(cornerRadius: InputSize.cornerRadius, padding: 0) {
                                Text(countryCode)
                                    .foregroundStyle(.white)
                                    .frame(width: 70)  // ✅ Reducido de 80 a 70
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, Spacing.xs)  // ✅ Reducido de sm a xs
                            }
                            
                            GlassTextField(
                                placeholder: "Número de teléfono",
                                text: $phoneNumber,
                                keyboardType: .phonePad
                            )
                            .focused($isPhoneFocused)
                        }
                        .padding(.horizontal, Spacing.md)  // ✅ Reducido padding horizontal de xl a md
                        
                        Spacer()
                        
                        // Botón enviar
                        VStack(spacing: Spacing.md) {  // ✅ Reducido spacing de lg a md
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
                            
                            Button("¿Problemas con el código?") {
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

