//
//  EventsHubView.swift
//  BoopApp
//
//  Events hub - Formato vertical tipo Instagram con Liquid Glass
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
                    VStack(spacing: 16) {
                        // Search bar compacto
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white.opacity(0.6))
                                .font(.system(size: 16))
                            
                            TextField("Buscar eventos...", text: $searchText)
                                .foregroundStyle(.white)
                                .font(.system(size: 15))
                                .focused($isSearchFocused)
                        }
                        .frame(height: 44)
                        .padding(.horizontal, 14)
                        .background {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.thinMaterial)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .strokeBorder(
                                    isSearchFocused ? Color.white.opacity(0.3) : Color.white.opacity(0.1),
                                    lineWidth: isSearchFocused ? 1.5 : 1
                                )
                        }
                        .padding(.horizontal, 24) // Mismo padding que los eventos
                        .padding(.top, 8)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearchFocused)
                        
                        // Events feed vertical (tipo Instagram)
                        LazyVStack(spacing: 12) {
                            ForEach(0..<10) { index in
                                EventFeedCard(eventNumber: index + 1)
                            }
                        }
                        .padding(.horizontal, 24) // Más padding para hacer eventos más estrechos
                        .padding(.bottom, 100) // Espacio para tab bar
                    }
                }
            }
            .navigationTitle("Inicio")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

// Evento individual estilo feed (tipo Instagram) - Versión compacta
struct EventFeedCard: View {
    let eventNumber: Int
    @State private var isPressed = false
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event image muy compacta para que quepa todo
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay {
                    Image(systemName: "music.note")
                        .font(.system(size: 40, weight: .light))
                        .foregroundStyle(.white.opacity(0.9))
                }
            
            // Info del evento muy compacta
            VStack(alignment: .leading, spacing: 4) {
                Text("Evento \(eventNumber)")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.white)
                
                HStack(spacing: 3) {
                    Image(systemName: "calendar")
                        .font(.system(size: 9))
                    Text("Vie 15 Dic · 21:00")
                        .font(.system(size: 10))
                }
                .foregroundStyle(.white.opacity(0.8))
                
                HStack(spacing: 3) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 9))
                    Text("Club Nocturno")
                        .font(.system(size: 10))
                }
                .foregroundStyle(.white.opacity(0.8))
                
                Text("Música electrónica y buena vibra!")
                    .font(.system(size: 11))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
                    .padding(.top, 1)
                
                // Action buttons con Liquid Glass real (muy compacto)
                HStack(spacing: 6) {
                    // Botón de Tickets (principal)
                    Button(action: {}) {
                        HStack(spacing: 3) {
                            Image(systemName: "ticket.fill")
                                .font(.system(size: 10))
                            Text("Tickets")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 28)
                        .background {
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        }
                    }
                    
                    Spacer()
                    
                    // Botones de acción con Liquid Glass (patrón oficial)
                    ActionButtonsGroup()
                }
                .padding(.top, 3)
            }
            .padding(8)
        }
        .background {
            // Liquid Glass container
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.2))
            } else {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.clear)
                        .glassEffect(.clear.interactive())
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                }
            }
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
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

// MARK: - Action Buttons con Liquid Glass real (patrón oficial de Apple)

struct ActionButtonsGroup: View {
    @State private var isLiked = false
    @State private var isSaved = false
    
    var body: some View {
        HStack(spacing: 5) {
            // Botón Like
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isLiked.toggle()
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .actionIcon(font: .system(size: 13))
                    .glassCircleButton(diameter: 30, tint: isLiked ? .red : .white)
            }
            
            // Botón Save/Bookmark
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isSaved.toggle()
                }
            }) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .actionIcon(font: .system(size: 13))
                    .glassCircleButton(diameter: 30, tint: .white)
            }
            
            // Botón Share
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .actionIcon(font: .system(size: 13))
                    .glassCircleButton(diameter: 30, tint: .white)
            }
        }
    }
}

#Preview {
    EventsHubView()
}

