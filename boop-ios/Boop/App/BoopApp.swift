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
                
                VStack(spacing: Spacing.xl) {
                    Spacer()
                    
                    Text("BOOP")
                        .font(.system(size: 36, weight: .bold))  // ✅ Reducido de 48 a 36
                        .foregroundStyle(.white)
                    
                    Text("Conecta con eventos increíbles")
                        .font(.system(size: 15))  // ✅ Reducido de 17 a 15
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Spacer()
                    
                    VStack(spacing: Spacing.md) {  // ✅ Reducido spacing de lg a md
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
                    .padding(.horizontal, Spacing.lg)
                    .padding(.bottom, Spacing.xl)  // ✅ Reducido de xxl a xl
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
    @State private var showCreateEvent = false
    
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
        // Liquid Glass: Minimizar tab bar al hacer scroll
        .tabBarMinimizeBehavior(.onScrollDown)
        // Liquid Glass: Botón de acción global flotante sobre la tab bar
        .tabViewBottomAccessory {
            if #available(iOS 26.0, *) {
                Button(action: {
                    showCreateEvent = true
                }) {
                    Label("Crear Evento", systemImage: "plus.circle.fill")
                        .font(.system(size: 17, weight: .semibold))
                }
                .buttonStyle(.glassProminent)
                .controlSize(.large)
                .padding(.horizontal, Spacing.lg)
            }
        }
        .sheet(isPresented: $showCreateEvent) {
            NavigationStack {
                CreateEventView()
            }
        }
    }
}

