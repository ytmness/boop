//
//  EventsHubView.swift
//  BoopApp
//
//  Events hub refactorizado - Cards sin glass (material sutil)
//

import SwiftUI

struct EventsHubView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Search bar - Material simple (sin glass pintado)
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white.opacity(0.6))
                            
                            TextField("Buscar eventos...", text: $searchText)
                                .foregroundStyle(.white)
                                .focused($isSearchFocused)
                        }
                        .frame(height: 52)
                        .padding(.horizontal, 16)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.thinMaterial)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    isSearchFocused ? Color.white.opacity(0.3) : Color.white.opacity(0.1),
                                    lineWidth: isSearchFocused ? 1.5 : 1
                                )
                        }
                        .padding(.horizontal, 16)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearchFocused)
                        
                        // Events grid
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(0..<10) { index in
                                EventCard(eventNumber: index + 1)
                            }
                        }
                        .padding(16)
                    }
                }
            }
            .navigationTitle("Eventos")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

struct EventCard: View {
    let eventNumber: Int
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Event image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 40))
                        .foregroundStyle(.white.opacity(0.8))
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Evento \(eventNumber)")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Descripción del evento")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
            }
        }
        .padding(12)
        .background {
            // Material sutil para cards estáticas (NO glass real)
            RoundedRectangle(cornerRadius: 16)
                .fill(.regularMaterial)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }
    }
}

#Preview {
    EventsHubView()
}

