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
                    VStack(spacing: 24) {
                        // Avatar
                        Circle()
                            .fill(.white.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 50))
                                    .foregroundStyle(.white)
                            }
                            .padding(.top)
                        
                        // Información
                        if let user = authViewModel.currentUser {
                            VStack(spacing: 8) {
                                Text(user.email ?? user.phone ?? "Usuario")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundStyle(.white)
                                
                                Text("ID: \(user.id.uuidString.prefix(8))")
                                    .font(.system(size: 14))
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
                        .padding()
                    }
                }
            }
            .navigationTitle("Perfil")
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

