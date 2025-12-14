import SwiftUI

/// Pantalla de Perfil
struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showSignOutAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: Spacing.xxl) {
                        // Avatar
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, Spacing.lg)
                        
                        // Información
                        if let user = authViewModel.currentUser {
                            VStack(spacing: Spacing.sm) {
                                Text(user.email ?? user.phone ?? "Usuario")
                                    .font(.system(size: Typography.title, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text("ID: \(user.id.uuidString.prefix(8))")
                                    .font(.system(size: Typography.caption))
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                        }
                        
                        // Botón cerrar sesión
                        GlassButton(
                            title: "Cerrar sesión",
                            action: {
                                showSignOutAlert = true
                            }
                        )
                        .padding(.horizontal, Spacing.lg)
                        // Liquid Glass: Padding inferior para extender debajo de la tab bar
                        .padding(.bottom, Spacing.xxxl)
                    }
                }
                // Liquid Glass: Asegurar que el scroll view se extienda debajo de la tab bar
                .ignoresSafeArea(.container, edges: .bottom)
            }
            .navigationTitle("Perfil")
            .navigationBarTitleDisplayMode(.large)
        }
        .alert("Cerrar sesión", isPresented: $showSignOutAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Cerrar sesión", role: .destructive) {
                Task {
                    try? await authViewModel.signOut()
                }
            }
        } message: {
            Text("¿Estás seguro de que quieres cerrar sesión?")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}

