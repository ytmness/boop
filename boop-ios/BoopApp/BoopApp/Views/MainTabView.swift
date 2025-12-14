//
//  MainTabView.swift
//  BoopApp
//
//  Main navigation with Liquid Glass Tab Bar
//

import SwiftUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @State private var showCreateEvent = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsHubView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Label("Explorar", systemImage: "map")
                }
                .tag(1)
            
            SearchView()
                .tabItem {
                    Label("Buscar", systemImage: "magnifyingglass")
                }
                .tag(2)
            
            // Tab invisible para el botón de Crear
            Color.clear
                .tabItem {
                    Label("Crear", systemImage: "plus.circle.fill")
                }
                .tag(3)
            
            ActivityView()
                .tabItem {
                    Label("Actividad", systemImage: "bell")
                }
                .tag(4)
            
            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Perfil", systemImage: "person.circle")
                }
                .tag(5)
        }
        // Tab bar automatically uses Liquid Glass in iOS 26
        .tint(.white)
        .onChange(of: selectedTab) { oldValue, newValue in
            // Si selecciona el tab de Crear (3), mostrar sheet
            if newValue == 3 {
                showCreateEvent = true
                // Volver al tab anterior
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    selectedTab = oldValue
                }
            }
        }
        .sheet(isPresented: $showCreateEvent) {
            CreateEventView()
        }
    }
}

// Vista temporal para crear eventos
struct CreateEventView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                VStack {
                    Text("Crear Nuevo Evento")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}
