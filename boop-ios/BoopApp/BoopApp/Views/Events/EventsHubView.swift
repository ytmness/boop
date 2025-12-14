//
//  EventsHubView.swift
//  BoopApp
//
//  Events Hub - Feed vertical optimizado con Liquid Glass
//

import SwiftUI

struct EventsHubView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                GlassAnimatedBackground()
                
                // Content con safe area dinámica
                GeometryReader { geometry in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Search bar
                            SearchBar(
                                text: $searchText,
                                isFocused: $isSearchFocused
                            )
                            .padding(.top, 8)
                            
                            // Events feed
                            ForEach(0..<10, id: \.self) { index in
                                EventFeedCard(eventNumber: index + 1)
                            }
                        }
                        .padding(.horizontal, 16)
                        // Safe area bottom dinámica
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 16)
                    }
                }
            }
            .navigationTitle("INICIO ✅ CAMBIO")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Search Bar Component

private struct SearchBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
                .font(.system(size: 16))
            
            TextField("Buscar eventos...", text: $text)
                .foregroundStyle(.white)
                .font(.system(size: 15))
                .focused(isFocused)
        }
        .frame(height: 44)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    isFocused.wrappedValue ? Color.white.opacity(0.3) : Color.white.opacity(0.1),
                    lineWidth: isFocused.wrappedValue ? 1.5 : 1
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused.wrappedValue)
    }
}

// MARK: - Event Feed Card (proporción 4:3 para móvil)

struct EventFeedCard: View {
    let eventNumber: Int
    @State private var isPressed = false
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Event image - altura fija compacta
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Image(systemName: "music.note")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(height: 160)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            // Event info
            VStack(alignment: .leading, spacing: 4) {
                // Título con DEBUG para verificar
                Text("DEBUG CARD ✅ Evento \(eventNumber)")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.yellow)
                
                // Fecha
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 11))
                    Text("Vie 15 Dic · 21:00")
                        .font(.system(size: 12))
                }
                .foregroundStyle(.white.opacity(0.8))
                
                // Ubicación
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 11))
                    Text("Club Nocturno")
                        .font(.system(size: 12))
                }
                .foregroundStyle(.white.opacity(0.8))
                
                // Descripción
                Text("Música electrónica y buena vibra!")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
                
                // Action buttons
                HStack(alignment: .center, spacing: 8) {
                    // Botón de Tickets
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "ticket.fill")
                                .font(.system(size: 11))
                            Text("Tickets")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
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
                    
                    // Botones de acción con Liquid Glass
                    ActionButtonsGroup()
                }
                .padding(.top, 4)
            }
            .padding(10)
        }
        .background {
            // Liquid Glass container
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(white: 0.2))
            } else {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(.regularMaterial)
                }
            }
        }
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
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

// MARK: - Action Buttons con Liquid Glass real

struct ActionButtonsGroup: View {
    @State private var isLiked = false
    @State private var isSaved = false
    
    var body: some View {
        HStack(spacing: 6) {
            // Botón Like
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isLiked.toggle()
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .actionIcon(font: .system(size: 14))
                    .glassCircleButton(diameter: 32, tint: isLiked ? .red : .white)
            }
            
            // Botón Save
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isSaved.toggle()
                }
            }) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .actionIcon(font: .system(size: 14))
                    .glassCircleButton(diameter: 32, tint: .white)
            }
            
            // Botón Share
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .actionIcon(font: .system(size: 14))
                    .glassCircleButton(diameter: 32, tint: .white)
            }
        }
    }
}

#Preview {
    EventsHubView()
}
