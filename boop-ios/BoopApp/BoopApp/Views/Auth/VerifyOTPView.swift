//
//  VerifyOTPView.swift
//  BoopApp
//
//  Pantalla de verificación OTP - 8 dígitos (compacta, centrada y keyboard-safe)
//

import SwiftUI

struct VerifyOTPView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    let email: String
    @Environment(\.dismiss) private var dismiss
    
    private let otpLength = 8
    
    @State private var otpCode: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            GlassAnimatedBackground()
            
            VStack {
                // ✅ HEADER CON BOTÓN BIEN POSICIONADO (AÚN MÁS A LA DERECHA)
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background {
                                Circle().fill(.ultraThinMaterial)
                            }
                    }
                    Spacer()
                }
                .padding(.leading, 56)   // ✅ AJUSTE FINAL
                .padding(.trailing, 16)
                .padding(.top, 8)
                
                // CONTENIDO QUE SE AJUSTA AL TECLADO
                ScrollView {
                    VStack {
                        Spacer(minLength: 40)
                        
                        VStack(spacing: 16) {
                            // Título
                            VStack(spacing: 6) {
                                Text("Verificar código")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(.white)
                                
                                Text("Ingresa el código de \(otpLength) dígitos enviado a")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.75))
                                    .multilineTextAlignment(.center)
                                
                                Text(email)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            .multilineTextAlignment(.center)
                            
                            // OTP boxes
                            HStack(spacing: 8) {
                                ForEach(0..<otpLength, id: \.self) { index in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(.thinMaterial)
                                            .frame(width: 36, height: 44)
                                        
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .stroke(
                                                Color.white.opacity(index < otpCode.count ? 0.6 : 0.2),
                                                lineWidth: 1.2
                                            )
                                        
                                        Text(digit(at: index))
                                            .font(.system(size: 18, weight: .semibold))
                                            .foregroundStyle(.white)
                                    }
                                }
                            }
                            
                            // Hidden input
                            TextField("", text: $otpCode)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .focused($isFocused)
                                .opacity(0)
                                .frame(width: 0, height: 0)
                            
                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                            
                            // Botones
                            VStack(spacing: 12) {
                                Button(action: verifyCode) {
                                    Text("Verificar")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 10)
                                }
                                .background {
                                    Capsule().fill(.ultraThinMaterial)
                                }
                                .disabled(viewModel.isLoading || otpCode.count != otpLength)
                                
                                Button("Reenviar código") {
                                    resendCode()
                                }
                                .font(.system(size: 13))
                                .foregroundStyle(.white.opacity(0.8))
                                .disabled(viewModel.isLoading)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: 360)
                        .frame(maxWidth: .infinity)
                        
                        Spacer(minLength: 60)
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            isFocused = true
        }
        .onChange(of: otpCode) { _, newValue in
            otpCode = String(newValue.filter(\.isNumber).prefix(otpLength))
            
            if otpCode.count == otpLength {
                verifyCode()
            }
        }
    }
    
    private func digit(at index: Int) -> String {
        guard index < otpCode.count else { return "" }
        return String(Array(otpCode)[index])
    }
    
    private func verifyCode() {
        guard otpCode.count == otpLength else {
            viewModel.errorMessage = "Ingresa el código completo"
            return
        }
        
        Task {
            do {
                try await viewModel.verifyOTP(email: email, token: otpCode)
            } catch {
                otpCode = ""
                isFocused = true
            }
        }
    }
    
    private func resendCode() {
        Task {
            try? await viewModel.sendOTP(email: email)
            otpCode = ""
            isFocused = true
        }
    }
}

#Preview {
    VerifyOTPView(email: "usuario@ejemplo.com")
        .environmentObject(AuthViewModel())
}
