//
//  VerifyOTPView.swift
//  BoopApp
//
//  Pantalla de verificación OTP - 6 dígitos
//

import SwiftUI

struct VerifyOTPView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    private let otpLength = 8
    @State private var codeDigits: [String] = Array(repeating: "", count: 8)
    @FocusState private var focusedIndex: Int?
    
    let email: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            ZStack {
                GlassAnimatedBackground()
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                }
                        }
                        Spacer()
                    }
                    .padding()
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Título
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Verificar código")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                                
                                Text("Ingresa el código de 8 dígitos enviado a")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white.opacity(0.8))
                                
                                Text(email)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                            
                            // Campos de código (8 dígitos)
                            HStack(spacing: 12) {
                                ForEach(0..<otpLength, id: \.self) { index in
                                TextField("", text: $codeDigits[index])
                                    .keyboardType(.numberPad)
                                    .textContentType(.oneTimeCode)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .focused($focusedIndex, equals: index)
                                    .frame(width: 50, height: 60)
                                    .background {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.thinMaterial)
                                    }
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .strokeBorder(
                                                focusedIndex == index ? Color.white.opacity(0.5) : Color.white.opacity(0.2),
                                                lineWidth: focusedIndex == index ? 2 : 1
                                            )
                                    }
                                    .onChange(of: codeDigits[index]) { oldValue, newValue in
                                        handleCodeChange(at: index, newValue: newValue)
                                    }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Error message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.horizontal)
                        }
                        
                        // Botón verificar
                        VStack(spacing: 16) {
                            Button(action: verifyCode) {
                                Text("Verificar")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 52)
                                    .background {
                                        Capsule()
                                            .fill(viewModel.isLoading ? Color.white.opacity(0.3) : Color.white.opacity(0.2))
                                    }
                            }
                            .disabled(viewModel.isLoading)
                            .padding(.horizontal)
                            
                            Button("Reenviar código") {
                                resendCode()
                            }
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.system(size: 14))
                            .disabled(viewModel.isLoading)
                        }
                        .padding(.bottom)
                    }
                    .padding(.top, 40)
                }
            }
        }
        .onAppear {
            focusedIndex = 0
        }
    }
    
    private func handleCodeChange(at index: Int, newValue: String) {
        // Solo permitir números y limitar a 1 dígito
        let filtered = newValue.filter(\.isNumber)
        codeDigits[index] = String(filtered.prefix(1))
        
        // Mover al siguiente campo
        if !codeDigits[index].isEmpty && index < (otpLength - 1) {
            focusedIndex = index + 1
        }
        
        // Verificar automáticamente cuando se completa
        let fullCode = codeDigits.joined()
        if fullCode.count == otpLength {
            verifyCode()
        }
    }
    
    private func verifyCode() {
        let code = codeDigits.joined()
        
        guard code.count == otpLength else {
            viewModel.errorMessage = "Por favor, ingresa el código completo de 8 dígitos"
            return
        }
        
        Task {
            do {
                try await viewModel.verifyOTP(email: email, token: code)
                // La navegación se maneja automáticamente cuando isAuthenticated cambia
            } catch {
                // Error manejado por viewModel.errorMessage
                // Limpiar campos
                codeDigits = Array(repeating: "", count: otpLength)
                focusedIndex = 0
            }
        }
    }
    
    private func resendCode() {
        Task {
            do {
                try await viewModel.sendOTP(email: email)
                // Limpiar campos
                codeDigits = Array(repeating: "", count: otpLength)
                focusedIndex = 0
            } catch {
                // Error manejado por viewModel.errorMessage
            }
        }
    }
}

#Preview {
    VerifyOTPView(email: "usuario@ejemplo.com")
        .environmentObject(AuthViewModel())
}

