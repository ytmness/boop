import SwiftUI

@main
struct BoopApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        // Inicializar Supabase
        _ = SupabaseConfig.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .task {
            authViewModel.checkAuthState()
        }
    }
}

// MARK: - Onboarding
struct OnboardingView: View {
    @State private var showPhoneLogin = false
    @State private var showEmailLogin = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    Text("BOOP")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Text("Conecta con eventos increíbles")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        Button {
                            showPhoneLogin = true
                        } label: {
                            GlassButton(title: "Continuar con Teléfono", action: {})
                        }
                        
                        Button {
                            showEmailLogin = true
                        } label: {
                            GlassButton(title: "Continuar con Email", style: .secondary, action: {})
                        }
                    }
                    .padding()
                }
            }
            .navigationDestination(isPresented: $showPhoneLogin) {
                PhoneLoginView()
            }
            .navigationDestination(isPresented: $showEmailLogin) {
                EmailLoginView()
            }
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    var body: some View {
        TabView {
            EventsHubView()
                .tabItem {
                    Label("Eventos", systemImage: "calendar")
                }
            
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
        .tint(.white)
    }
}

