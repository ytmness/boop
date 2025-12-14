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
                
                // Content sin GeometryReader (evita expansión forzada)
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
                    .padding(.bottom, 16)
                }
                // Extender contenido debajo de la tab bar para efecto blur
                .ignoresSafeArea(.container, edges: .bottom)
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
    @Environment(\.horizontalSizeClass) private var hSize
    
    private var isCompact: Bool {
        hSize == .compact
    }
    
    var body: some View {
        Group {
            if isCompact {
                compactCard
            } else {
                wideCard
            }
        }
        .padding(.horizontal, 12)  // ✅ evita que toque bordes pantalla
        .padding(.vertical, 8)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) { isPressed = false }
            }
        }
    }
    
    // MARK: - Compact Card (Vertical - Overlay design)
    private var compactCard: some View {
        ZStack(alignment: .bottomLeading) {
            // MEDIA
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Image(systemName: "music.note")
                    .font(.system(size: 38, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(height: 210)  // ✅ más "cuerpo" en vertical
            .clipped()
            
            // OVERLAY (INFO + ACCIONES) como una sola pieza
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Evento \(eventNumber)")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Spacer(minLength: 8)
                }
                
                HStack(spacing: 10) {
                    Label("Vie 15 Dic · 21:00", systemImage: "calendar")
                    Label("Club Nocturno", systemImage: "mappin.circle.fill")
                }
                .font(.caption)
                .foregroundStyle(.white.opacity(0.85))
                .lineLimit(1)
                
                Text("Música electrónica y buena vibra!")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                    .lineLimit(2)
                
                HStack(spacing: 10) {
                    if #available(iOS 26.0, *) {
                        Button { } label: {
                            Label("Tickets", systemImage: "ticket")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.purple)
                        .frame(height: 44)  // ✅ ya no "delgado"
                    } else {
                        ticketsButton
                    }
                    
                    if #available(iOS 26.0, *) {
                        HStack(spacing: 8) {
                            iconGlassButton("heart")
                            iconGlassButton("bookmark")
                            iconGlassButton("paperplane")
                        }
                    } else {
                        ActionButtonsGroup()
                    }
                }
            }
            .padding(12)  // ✅ esto evita recorte izquierda
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.thinMaterial)
                }
            }
            .padding(12)  // ✅ separa overlay del borde del media
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))  // ✅ clip final (1 sola vez)
        .background {
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(white: 0.2))
            } else {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.regularMaterial)
                }
            }
        }
    }
    
    // MARK: - Icon Glass Button Helper
    @available(iOS 26.0, *)
    private func iconGlassButton(_ name: String) -> some View {
        Button(action: {}) {
            Image(systemName: name)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.glass)
    }
    
    // MARK: - Wide Card (Horizontal - Layout actual)
    private var wideCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                LinearGradient(
                    colors: [Color.blue, Color.purple, Color.pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                Image(systemName: "music.note")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(height: 190)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Evento \(eventNumber)")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar").font(.system(size: 11))
                    Text("Vie 15 Dic · 21:00").font(.system(size: 12))
                }
                .foregroundStyle(.white.opacity(0.8))
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle.fill").font(.system(size: 11))
                    Text("Club Nocturno").font(.system(size: 12))
                }
                .foregroundStyle(.white.opacity(0.8))
                
                Text("Música electrónica y buena vibra!")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    ticketsButton
                    ActionButtonsGroup()
                }
                .padding(.top, 6)
            }
            .padding(12)
        }
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .background {
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(white: 0.2))
            } else {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.regularMaterial)
                }
            }
        }
    }
    
    // MARK: - Tickets Button
    private var ticketsButton: some View {
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
