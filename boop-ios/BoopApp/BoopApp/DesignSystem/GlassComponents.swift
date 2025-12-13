//
//  GlassComponents.swift
//  BoopApp
//
//  Design System para Liquid Glass
//  Preparado para iOS 26+ con fallback para versiones anteriores
//

import SwiftUI

// MARK: - Glass Card Component

struct GlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    init(
        cornerRadius: CGFloat = 24,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(20)
            .background {
                if reduceTransparency {
                    // Modo accesibilidad: fondo sólido
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color(white: 0.2))
                } else {
                    // Liquid Glass completo
                    ZStack {
                        // Capa 1: Material base
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(.ultraThinMaterial)
                        
                        // Capa 2: Gradiente de luz
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.15),
                                        Color.white.opacity(0.05),
                                        Color.white.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Capa 3: Borde brillante (efecto lente)
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.6),
                                        Color.white.opacity(0.2),
                                        Color.white.opacity(0.4)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    }
                    // Sombras para profundidad
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
                    .shadow(color: .white.opacity(0.1), radius: 5, x: 0, y: -2)
                }
            }
    }
}

// MARK: - Glass Button Component

struct GlassButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    
    @State private var isPressed = false
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    enum ButtonStyle {
        case regular
        case prominent
        case tinted(Color)
    }
    
    init(
        _ title: String,
        style: ButtonStyle = .regular,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    var body: some View {
        Button(action: handleTap) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(isProminent ? 18 : 14)
                .background {
                    if reduceTransparency {
                        Capsule().fill(buttonColor)
                    } else {
                        glassBackground
                    }
                }
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .brightness(isPressed ? -0.1 : 0)
        .animation(reduceMotion ? .none : .spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
    
    private var isProminent: Bool {
        if case .prominent = style { return true }
        if case .tinted = style { return true }
        return false
    }
    
    private var buttonColor: Color {
        switch style {
        case .prominent: return .blue
        case .tinted(let color): return color
        case .regular: return Color(white: 0.3)
        }
    }
    
    private var glassBackground: some View {
        ZStack {
            Capsule()
                .fill(.ultraThinMaterial)
            
            Capsule()
                .fill(gradientFill)
            
            Capsule()
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.5),
                            Color.white.opacity(0.2)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        }
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
        .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
    }
    
    private var gradientFill: LinearGradient {
        switch style {
        case .prominent:
            return LinearGradient(
                colors: [
                    Color.blue.opacity(0.4),
                    Color.purple.opacity(0.3),
                    Color.blue.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .tinted(let color):
            return LinearGradient(
                colors: [
                    color.opacity(0.4),
                    color.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .regular:
            return LinearGradient(
                colors: [
                    Color.white.opacity(0.15),
                    Color.white.opacity(0.05),
                    Color.white.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .prominent: return .blue.opacity(0.3)
        case .tinted(let color): return color.opacity(0.3)
        case .regular: return .white.opacity(0.1)
        }
    }
    
    private func handleTap() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            isPressed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = false
            }
            action()
        }
    }
}

// MARK: - Glass TextField Component

struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String?
    let isSecure: Bool
    
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @FocusState private var isFocused: Bool
    
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
        HStack(spacing: 12) {
            if let icon {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 20)
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
        .padding(16)
        .background {
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(white: 0.25))
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.thinMaterial)
                    
                    RoundedRectangle(cornerRadius: 14)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.1),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(
                            isFocused ?
                            LinearGradient(
                                colors: [.blue.opacity(0.6), .purple.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) :
                            LinearGradient(
                                colors: [.white.opacity(0.3), .white.opacity(0.1)],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: isFocused ? 2 : 1
                        )
                }
                .shadow(color: isFocused ? .blue.opacity(0.3) : .black.opacity(0.2), radius: isFocused ? 15 : 8, x: 0, y: 4)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
    }
}

// MARK: - Glass Background with Animation

struct GlassAnimatedBackground: View {
    @State private var animateGradient = false
    @State private var rotationAngle: Double = 0
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.05, blue: 0.25),
                    Color.black,
                    Color(red: 0.15, green: 0.1, blue: 0.35)
                ],
                startPoint: animateGradient ? .topLeading : .bottomLeading,
                endPoint: animateGradient ? .bottomTrailing : .topTrailing
            )
            
            // Orb 1 - Azul
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.blue.opacity(0.4),
                            Color.cyan.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 500, height: 500)
                .offset(
                    x: animateGradient ? -50 : 100,
                    y: animateGradient ? -100 : 50
                )
                .blur(radius: 80)
                .rotationEffect(.degrees(rotationAngle))
            
            // Orb 2 - Púrpura
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.purple.opacity(0.4),
                            Color.pink.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 500, height: 500)
                .offset(
                    x: animateGradient ? 100 : -50,
                    y: animateGradient ? 150 : -100
                )
                .blur(radius: 80)
                .rotationEffect(.degrees(-rotationAngle * 0.7))
            
            // Orb 3 - Rosa
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.pink.opacity(0.3),
                            Color.orange.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 250
                    )
                )
                .frame(width: 400, height: 400)
                .offset(
                    x: animateGradient ? -80 : 80,
                    y: animateGradient ? 100 : -150
                )
                .blur(radius: 70)
                .rotationEffect(.degrees(rotationAngle * 0.5))
        }
        .ignoresSafeArea()
        .onAppear {
            if !reduceMotion {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    animateGradient = true
                }
                withAnimation(.linear(duration: 30).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
        }
    }
}

// MARK: - Preview Helpers

#Preview("Glass Card") {
    ZStack {
        GlassAnimatedBackground()
        
        GlassCard {
            VStack(spacing: 12) {
                Text("Liquid Glass")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Efecto de vidrio translúcido con múltiples capas")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
            }
            .foregroundStyle(.white)
        }
        .padding()
    }
}

#Preview("Glass Button") {
    ZStack {
        GlassAnimatedBackground()
        
        VStack(spacing: 20) {
            GlassButton("Regular", action: {})
            GlassButton("Prominent", style: .prominent, action: {})
            GlassButton("Tinted", style: .tinted(.green), action: {})
        }
        .padding()
    }
}

#Preview("Glass TextField") {
    ZStack {
        GlassAnimatedBackground()
        
        VStack(spacing: 16) {
            GlassTextField("Email", text: .constant(""), icon: "envelope")
            GlassTextField("Contraseña", text: .constant(""), icon: "lock", isSecure: true)
        }
        .padding()
    }
}

