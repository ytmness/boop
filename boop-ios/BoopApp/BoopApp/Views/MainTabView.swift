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
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsHubView()
                .tabItem {
                    Label("Eventos", systemImage: "calendar")
                }
                .tag(0)
            
            ExploreView()
                .tabItem {
                    Label("Explorar", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            ProfileView(authViewModel: authViewModel)
                .tabItem {
                    Label("Perfil", systemImage: "person.circle")
                }
                .tag(2)
        }
        // Tab bar automatically uses Liquid Glass in iOS 26
        .tint(.white)
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}

