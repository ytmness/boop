//
//  ProfileView.swift
//  BoopApp
//
//  Profile view refactorizado - Sin overlays, material simple
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile header - Material simple (NO glass)
                        VStack(spacing: 16) {
                            // Profile image - Material simple sin overlays
                            Circle()
                                .fill(.thinMaterial)
                                .frame(width: 120, height: 120)
                                .overlay {
                                    Image(systemName: "person.circle.fill")
                                        .font(.system(size: 80))
                                        .foregroundStyle(.white)
                                }
                            
                            Text("Usuario")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text("usuario@email.com")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                        }
                        .padding(20)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.thinMaterial)
                        }
                        .padding(.horizontal, 16)
                        
                        // Menu options - Material simple
                        VStack(spacing: 8) {
                            ProfileMenuItem(icon: "person", title: "Editar Perfil")
                            ProfileMenuItem(icon: "ticket", title: "Mis Tickets")
                            ProfileMenuItem(icon: "heart", title: "Favoritos")
                            ProfileMenuItem(icon: "gear", title: "Configuración")
                            ProfileMenuItem(icon: "questionmark.circle", title: "Ayuda")
                        }
                        .padding(16)
                        .background {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.thinMaterial)
                        }
                        .padding(.horizontal, 16)
                        
                        // Logout button - Glass real (botón flotante)
                        SimpleGlassButton("Cerrar Sesión", tint: .red) {
                            authViewModel.logout()
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.vertical, 24)
                }
            }
            .navigationTitle("Perfil")
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isPressed = false
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(.white)
                    .frame(width: 24)
                    .font(.system(size: 18))
                
                Text(title)
                    .foregroundStyle(.white)
                    .font(.body)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.4))
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background {
                // Material simple para items de menú
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThinMaterial)
            }
        }
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }
}

// Helper para botón con tint
private struct SimpleGlassButton: View {
    let title: String
    let tint: Color?
    let action: () -> Void
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    init(_ title: String, tint: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.tint = tint
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(tint ?? .white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .padding(.horizontal, 24)
        }
        .buttonStyle(SimpleGlassButtonStyle(tint: tint))
    }
}

private struct SimpleGlassButtonStyle: ButtonStyle {
    let tint: Color?
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background {
                if reduceTransparency {
                    Capsule()
                        .fill(tint?.opacity(0.5) ?? Color(white: 0.3))
                } else {
                    if #available(iOS 26.0, *) {
                        Capsule()
                            .fill(Color.clear)
                            .glassEffect(.clear.interactive())
                    } else {
                        Capsule()
                            .fill(.ultraThinMaterial)
                    }
                }
            }
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}

