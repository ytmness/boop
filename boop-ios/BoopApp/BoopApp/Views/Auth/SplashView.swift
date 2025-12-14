//
//  SplashView.swift
//  BoopApp
//
//  Splash screen con animación Liquid Glass
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var rotationDegrees: Double = 0
    
    var body: some View {
        ZStack {
            GlassAnimatedBackground()
            
            // Logo animado con efecto glass
            ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.blue.opacity(0.2),
                                            Color.purple.opacity(0.15),
                                            Color.clear
                                        ],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 100
                                    )
                                )
                        }
                        .overlay {
                            Circle()
                                .strokeBorder(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.8),
                                            Color.blue.opacity(0.5),
                                            Color.purple.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        }
                        .shadow(color: .blue.opacity(0.5), radius: 40, x: 0, y: 20)
                        .shadow(color: .purple.opacity(0.4), radius: 30, x: 0, y: 10)
                        .shadow(color: .white.opacity(0.3), radius: 20, x: 0, y: -10)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 80, weight: .thin))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan, .blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .rotationEffect(.degrees(rotationDegrees))
                }
                .frame(width: 180, height: 180)
                .scaleEffect(scale)
                .opacity(opacity)
                
                // Texto BOOP con efecto glass
                VStack(spacing: 12) {
                    Text("BOOP")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: .blue.opacity(0.5), radius: 20, x: 0, y: 10)
                    
                    Text("Eventos que brillan")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .offset(y: 140)
                .opacity(opacity)
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.spring(response: 1.2, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) {
                rotationDegrees = 360
            }
        }
    }
}

#Preview {
    SplashView()
}

