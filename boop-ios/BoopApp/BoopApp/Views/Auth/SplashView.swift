//
//  SplashView.swift
//  BoopApp
//
//  Splash screen - Liquid Glass iOS 26
//

import SwiftUI

struct SplashView: View {
    @State private var scale: CGFloat = 0.6
    @State private var opacity: Double = 0
    @State private var rotationDegrees: Double = 0
    
    var body: some View {
        ZStack {
            GlassAnimatedBackground()
            
            VStack(spacing: 28) {
                
                // ✅ LOGO LIQUID GLASS
                ZStack {
                    if #available(iOS 26.0, *) {
                        Circle()
                            .fill(Color.clear)
                            .glassEffect(.clear.interactive())
                    } else {
                        Circle()
                            .fill(.ultraThinMaterial)
                    }
                    
                    // ✅ DISCO DE MÚSICA (VINILO)
                    ZStack {
                        Image(systemName: "record.circle.fill")
                            .font(.system(size: 110))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        .white,
                                        .cyan.opacity(0.9),
                                        .blue.opacity(0.9),
                                        .purple.opacity(0.9)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                        
                        // Centro del disco
                        Circle()
                            .fill(.black.opacity(0.8))
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .fill(.white.opacity(0.4))
                                    .frame(width: 6, height: 6)
                            )
                    }
                    .rotationEffect(.degrees(rotationDegrees))
                }
                .frame(width: 180, height: 180)
                .scaleEffect(scale)
                .opacity(opacity)
                .shadow(color: .blue.opacity(0.35), radius: 30, x: 0, y: 20)
                .shadow(color: .purple.opacity(0.25), radius: 20, x: 0, y: 10)
                
                // ✅ TEXTO
                VStack(spacing: 10) {
                    Text("BOOP")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .cyan, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("Eventos que brillan")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .opacity(opacity)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Entrada del logo
            withAnimation(.spring(response: 1.2, dampingFraction: 0.6)) {
                scale = 1.0
                opacity = 1.0
            }
            
            // Rotación tipo vinilo
            withAnimation(.linear(duration: 18).repeatForever(autoreverses: false)) {
                rotationDegrees = 360
            }
        }
    }
}

#Preview {
    SplashView()
}
