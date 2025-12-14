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
                        LazyVStack(spacing: 24) {  // ✅ Más espacio entre posts tipo Instagram
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
                        .padding(.horizontal, 16)  // ✅ Padding horizontal restaurado
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
    @State private var isLiked = false
    @State private var isSaved = false
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
    
    // MARK: - Compact Card (Instagram-style post)
    private var compactCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // MEDIA - Imagen más grande (aproximadamente el doble)
            ZStack {
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Image(systemName: "music.note")
                    .font(.system(size: 100, weight: .semibold))  // ✅ Duplicado de 50 a 100
                    .foregroundStyle(.white.opacity(0.9))
            }
            .frame(height: 400)  // ✅ Altura fija grande (aproximadamente el doble)
            .frame(maxWidth: .infinity)
            .clipped()
            
            // INFO SECTION - Debajo de la imagen (tipo Instagram)
            VStack(alignment: .leading, spacing: 20) {  // ✅ Spacing aumentado de 12 a 20
                // Botones de acción (restaurados - pequeños con glassCircle)
                HStack(spacing: 16) {  // ✅ Spacing aumentado de 10 a 16
                    if #available(iOS 26.0, *) {
                        likeButton
                        saveButton
                        shareButton
                    } else {
                        ActionButtonsGroup()
                    }
                    
                    Spacer()
                    
                    // Botón Tickets compacto
                    if #available(iOS 26.0, *) {
                        Button { } label: {
                            Label("Tickets", systemImage: "ticket")
                                .font(.system(size: 18, weight: .semibold))  // ✅ Aumentado de 15 a 18
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.purple)
                        .frame(height: 44)  // ✅ Aumentado de 36 a 44
                        .fixedSize(horizontal: true, vertical: false)  // ✅ Evitar truncamiento
                        .padding(.horizontal, 24)  // ✅ Padding suficiente para el texto completo
                    } else {
                        ticketsButton
                    }
                }
                .padding(.horizontal, 32)  // ✅ Padding aumentado de 24 a 32
                .padding(.top, 20)  // ✅ Padding aumentado de 12 a 20
                
                // Título y descripción
                VStack(alignment: .leading, spacing: 10) {  // ✅ Spacing aumentado de 6 a 10
                    Text("Evento \(eventNumber)")
                        .font(.system(size: 22, weight: .semibold))  // ✅ Aumentado de 15 a 22
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text("Música electrónica y buena vibra!")
                        .font(.system(size: 18))  // ✅ Aumentado de 14 a 18
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(3)
                }
                .padding(.horizontal, 32)  // ✅ Padding aumentado de 24 a 32
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Fecha y ubicación
                HStack(spacing: 16) {  // ✅ Spacing aumentado de 12 a 16
                    Label("Vie 15 Dic · 21:00", systemImage: "calendar")
                    Label("Club Nocturno", systemImage: "mappin.circle.fill")
                }
                .font(.system(size: 16))  // ✅ Aumentado de 12 a 16
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 32)  // ✅ Padding aumentado de 24 a 32
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 24)  // ✅ Padding aumentado de 16 a 24
        }
        .padding(.horizontal, 16)  // ✅ Padding externo estándar
        .background {
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 32, style: .continuous)  // ✅ Más redondeado tipo burbuja
                    .fill(Color(white: 0.2))
            } else {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)  // ✅ Más redondeado tipo burbuja
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)  // ✅ Más redondeado tipo burbuja
                        .fill(.regularMaterial)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))  // ✅ Más redondeado tipo burbuja
    }
    
    // MARK: - Glass Circle Background
    private var glassCircle: some View {
        Group {
            if #available(iOS 26.0, *) {
                Circle()
                    .glassEffect(.regular, in: Circle())
            } else {
                Circle()
                    .fill(.ultraThinMaterial)
            }
        }
    }
    
    // MARK: - Like Button con animación y relleno (restaurado - pequeño)
    @available(iOS 26.0, *)
    private var likeButton: some View {
        Button {
            withAnimation(.bouncy(duration: 0.35)) {
                isLiked.toggle()
            }
        } label: {
            Image(systemName: isLiked ? "heart.fill" : "heart")
                .font(.system(size: 22, weight: .semibold))  // ✅ Aumentado de 16 a 22
                .foregroundStyle(isLiked ? .red : .white.opacity(0.9))
                .contentTransition(.symbolEffect(.replace))  // ✅ swap suave
                .symbolEffect(.bounce, value: isLiked)  // ✅ pop evidente
                .frame(width: 48, height: 48)  // ✅ Aumentado de 34 a 48
                .background(glassCircle)
        }
        .buttonStyle(.plain)  // ✅ evita que SwiftUI cambie el look
        .contentShape(Circle())
    }
    
    // MARK: - Save Button con animación y relleno (restaurado - pequeño)
    @available(iOS 26.0, *)
    private var saveButton: some View {
        Button {
            withAnimation(.bouncy(duration: 0.35)) {
                isSaved.toggle()
            }
        } label: {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.system(size: 22, weight: .semibold))  // ✅ Aumentado de 16 a 22
                .foregroundStyle(.white.opacity(0.9))
                .contentTransition(.symbolEffect(.replace))  // ✅
                .symbolEffect(.bounce, value: isSaved)  // ✅ pop evidente
                .frame(width: 48, height: 48)  // ✅ Aumentado de 34 a 48
                .background(glassCircle)
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
    
    // MARK: - Share Button (restaurado - pequeño)
    @available(iOS 26.0, *)
    private var shareButton: some View {
        Button {
            // share action
        } label: {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 22, weight: .semibold))  // ✅ Aumentado de 16 a 22
                .foregroundStyle(.white.opacity(0.9))
                .frame(width: 48, height: 48)  // ✅ Aumentado de 34 a 48
                .background(glassCircle)
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
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
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))  // ✅ Más redondeado para la imagen
            
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
            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))  // ✅ Más redondeado tipo burbuja
        .background {
            if reduceTransparency {
                RoundedRectangle(cornerRadius: 32, style: .continuous)  // ✅ Más redondeado tipo burbuja
                    .fill(Color(white: 0.2))
            } else {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)  // ✅ Más redondeado tipo burbuja
                        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 32, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)  // ✅ Más redondeado tipo burbuja
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
