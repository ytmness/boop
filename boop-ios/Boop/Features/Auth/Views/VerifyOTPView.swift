import SwiftUI

/// Pantalla de Verificación OTP - 8 dígitos, igual que Flutter
struct VerifyOTPView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var codeDigits: [String] = Array(repeating: "", count: 8)
    @FocusState private var focusedIndex: Int?
    
    let phoneOrEmail: String
    let isEmail: Bool
    
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
                    VStack(alignment: .leading, spacing: 32) {
                        // Título
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Verificar código")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundStyle(.white)
                            
                            Text("Ingresa el código de 8 dígitos")
                                .font(.system(size: 16))
                                .foregroundStyle(.white.opacity(0.8))
                        }
                        .padding(.horizontal)
                        
                        // Campos de código (8 dígitos)
                        HStack(spacing: 12) {
                            ForEach(0..<8, id: \.self) { index in
                                GlassContainer(cornerRadius: 12, padding: 0) {
                                    TextField("", text: $codeDigits[index])
                                        .keyboardType(.numberPad)
                                        .textContentType(.oneTimeCode)
                                        .multilineTextAlignment(.center)
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .focused($focusedIndex, equals: index)
                                        .onChange(of: codeDigits[index]) { oldValue, newValue in
                                            handleCodeChange(at: index, newValue: newValue)
                                        }
                                        .frame(width: 40, height: 50)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Botón verificar
                        VStack(spacing: 16) {
                            GlassButton(
                                title: "Verificar",
                                action: verifyCode,
                                isLoading: viewModel.isLoading
                            )
                            .padding(.horizontal)
                            
                            Button("Reenviar código") {
                                resendCode()
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
        .onAppear {
            focusedIndex = 0
        }
    }
    
    private func handleCodeChange(at index: Int, newValue: String) {
        // Solo permitir un dígito
        if newValue.count > 1 {
            codeDigits[index] = String(newValue.prefix(1))
        }
        
        // Mover al siguiente campo
        if !codeDigits[index].isEmpty && index < 7 {
            focusedIndex = index + 1
        }
        
        // Verificar automáticamente cuando se completa
        let fullCode = codeDigits.joined()
        if fullCode.count == 8 {
            verifyCode()
        }
    }
    
    private func verifyCode() {
        let code = codeDigits.joined()
        
        guard code.count == 8 || code.count == 6 else {
            viewModel.errorMessage = "Código incompleto"
            return
        }
        
        Task {
            do {
                if isEmail {
                    try await viewModel.verifyEmailOTP(email: phoneOrEmail, token: code)
                } else {
                    try await viewModel.verifyOTP(phone: phoneOrEmail, token: code)
                }
                
                // La navegación se maneja automáticamente cuando isAuthenticated cambia
                // en BoopApp.swift
            } catch {
                // Error manejado por viewModel.errorMessage
                // Limpiar campos
                codeDigits = Array(repeating: "", count: 8)
                focusedIndex = 0
            }
        }
    }
    
    private func resendCode() {
        Task {
            do {
                if isEmail {
                    try await viewModel.signInWithEmail(phoneOrEmail)
                } else {
                    try await viewModel.signInWithPhone(phoneOrEmail)
                }
            } catch {
                // Error manejado por viewModel.errorMessage
            }
        }
    }
}

#Preview {
    VerifyOTPView(phoneOrEmail: "+1234567890", isEmail: false)
}

