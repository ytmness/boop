//
//  VerifyOTPView.swift
//  BoopApp
//
//  Pantalla de verificación OTP - 8 dígitos
//

import SwiftUI

struct VerifyOTPView: View {
    // MARK: - Dependencies
    @EnvironmentObject var viewModel: AuthViewModel
    let email: String
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - OTP Config
    private let otpLength = 8
    
    // MARK: - State
    @State private var otpCode: String = ""
    @FocusState private var focusedField: Int?
    
    // MARK: - Body
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
                            
                            Text("Ingresa el código de \(otpLength) dígitos enviado a")
                                .font(.system(size: 16))
                                .foregroundStyle(.white.opacity(0.8))
                            
                            Text(email)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        
                        // Campos de código (8 dígitos)
                        HStack(spacing: 12) {
                            ForEach(0..<otpLength, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(.thinMaterial)
                                        .frame(width: 50, height: 60)
                                    
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(
                                            focusedField == index ? Color.white.opacity(0.5) : Color.white.opacity(0.2),
                                            lineWidth: focusedField == index ? 2 : 1
                                        )
                                        .frame(width: 50, height: 60)
                                    
                                    Text(digit(at: index))
                                        .font(.system(size: 24, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                                .onTapGesture {
                                    focusedField = index
                                }
                            }
                        }
                        
                        // Campo oculto para capturar input
                        TextField("", text: $otpCode)
                            .keyboardType(.numberPad)
                            .textContentType(.oneTimeCode)
                            .focused($focusedField, equals: 0)
                            .opacity(0)
                            .frame(width: 0, height: 0)
                        
                        // Error message
                        if let error = viewModel.errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        
                        // Botón verificar
                        VStack(spacing: 16) {
                            Button(action: verifyCode) {
                                Text("Verificar")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 22)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                            .cornerRadius(14)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .disabled(viewModel.isLoading || otpCode.count != otpLength)
                            
                            Button("Reenviar código") {
                                resendCode()
                            }
                            .foregroundStyle(.white.opacity(0.8))
                            .font(.system(size: 14))
                            .disabled(viewModel.isLoading)
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: 420)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }
        }
        .onAppear {
            focusedField = 0
        }
        .onChange(of: otpCode) { _, newValue in
            otpCode = String(newValue.filter(\.isNumber).prefix(otpLength))
            
            // Verificar automáticamente cuando se completa
            if otpCode.count == otpLength {
                verifyCode()
            }
        }
    }
    
    // MARK: - Helpers
    private func digit(at index: Int) -> String {
        guard index < otpCode.count else { return "" }
        let chars = Array(otpCode)
        return String(chars[index])
    }
    
    private func verifyCode() {
        guard otpCode.count == otpLength else {
            viewModel.errorMessage = "Por favor, ingresa el código completo de 8 dígitos"
            return
        }
        
        Task {
            do {
                try await viewModel.verifyOTP(email: email, token: otpCode)
                // La navegación se maneja automáticamente cuando isAuthenticated cambia
            } catch {
                // Error manejado por viewModel.errorMessage
                otpCode = ""
                focusedField = 0
            }
        }
    }
    
    private func resendCode() {
        Task {
            do {
                try await viewModel.sendOTP(email: email)
                otpCode = ""
                focusedField = 0
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
