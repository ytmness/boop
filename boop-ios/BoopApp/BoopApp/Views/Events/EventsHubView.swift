//
//  EventsHubView.swift
//  BoopApp
//
//  Events Hub - Feed vertical optimizado con Liquid Glass
//

import SwiftUI

struct EventsHubView: View {
    @State private var selectedTab: EventsTab = .explore
    @State private var selectedFilter: EventFilter = .all
    @State private var scrollOffset: CGFloat = 0
    
    enum EventsTab: String, CaseIterable {
        case explore = "Explorar"
        case following = "Siguiendo"
        case myEvents = "Mis Eventos"
    }
    
    enum EventFilter: String, CaseIterable {
        case all = "Todos"
        case host = "Anfitrión"
        case tickets = "Tickets"
        case history = "Historial"
    }
    
    private let headerHeight: CGFloat = 110
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Fondo decorativo (nunca debe bloquear taps)
                GlassAnimatedBackground()
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                
                // Feed
                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Lector de offset
                        Color.clear
                            .frame(height: 1)
                            .background(
                                GeometryReader { geometry in
                                    Color.clear.preference(
                                        key: ScrollOffsetPreferenceKey.self,
                                        value: geometry.frame(in: .named("scroll")).minY
                                    )
                                }
                            )
                        
                        // FEED
                        ForEach(0..<10, id: \.self) { index in
                            EventFeedCard(
                                eventNumber: index + 1,
                                tabType: selectedTab
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                    }
                    .padding(.top, headerHeight + 10) // deja espacio para el header fijo
                    .padding(.bottom, 24)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        scrollOffset = max(0, -value)
                    }
                }
                .zIndex(0)
                
                // Header fijo (BOOP + burbujas)
                HomeOverlayHeader(
                    selectedTab: $selectedTab,
                    selectedFilter: $selectedFilter,
                    scrollOffset: scrollOffset,
                    height: headerHeight
                )
                .frame(maxWidth: .infinity, alignment: .top)
                .padding(.top, 0)
                .zIndex(10) // CLAVE: siempre arriba
            }
            .navigationBarHidden(true)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarBackground(.hidden, for: .tabBar)
        }
    }
}

// MARK: - Scroll Offset Preference Key
private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Home Overlay Header
private struct HomeOverlayHeader: View {
    @Binding var selectedTab: EventsHubView.EventsTab
    @Binding var selectedFilter: EventsHubView.EventFilter
    let scrollOffset: CGFloat
    let height: CGFloat
    
    private var isCollapsed: Bool { scrollOffset > 30 }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                Text("BOOP")
                    .font(.system(size: isCollapsed ? 26 : 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 6)
                
                // Burbujas siempre visibles (filtros de pestañas) - Centradas como en SearchView
                GeometryReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(EventsHubView.EventsTab.allCases, id: \.self) { tab in
                                GlassTabChip(
                                    title: tab.rawValue,
                                    isSelected: selectedTab == tab
                                ) {
                                    withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                                        selectedTab = tab
                                    }
                                }
                            }
                        }
                        // Centrado con padding simétrico
                        .frame(minWidth: proxy.size.width, alignment: .center)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                    }
                }
                .frame(height: 44)
                
                // Filter bar (solo para My Events)
                if selectedTab == .myEvents {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(EventsHubView.EventFilter.allCases, id: \.self) { filter in
                                FilterChip(
                                    title: filter.rawValue,
                                    isSelected: selectedFilter == filter
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                        .padding(.leading, 24)
                        .padding(.trailing, 16)
                        .padding(.vertical, 8)
                    }
                }
            }
            .padding(.top, geo.safeAreaInsets.top - 20) // Sube BOOP y burbujas
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .background(Color.clear) // sin recuadro
    }
}

// MARK: - Glass Tab Chip
private struct GlassTabChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.85))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .background {
            Group {
                if #available(iOS 26.0, *) {
                    Capsule()
                        .fill(Color.clear)
                        .glassEffect(.clear.interactive())
                } else {
                    ZStack {
                        Capsule().fill(.ultraThinMaterial)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isSelected ? 0.18 : 0.10),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Capsule()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isSelected ? 0.55 : 0.28),
                                        .white.opacity(isSelected ? 0.20 : 0.10)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                }
            }
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.28, dampingFraction: 0.78), value: isSelected)
    }
}

// MARK: - Filter Chip
private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(isSelected ? .black : .white)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background {
                    Capsule()
                        .fill(isSelected ? .white : .white.opacity(0.15))
                }
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
    var tabType: EventsHubView.EventsTab = .explore
    @State private var isPressed = false
    @State private var isLiked = false
    @State private var isSaved = false
    @Environment(\.accessibilityReduceTransparency) var reduceTransparency
    @Environment(\.horizontalSizeClass) private var hSize
    
    private var isCompact: Bool {
        hSize == .compact
    }
    
    // MARK: - Event Theme (diferentes gradientes e iconos por evento)
    private var eventTheme: (gradient: LinearGradient, icon: String, iconSize: CGFloat) {
        switch eventNumber % 6 {
        case 0:
            return (
                LinearGradient(colors: [.blue, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                "music.note",
                100
            )
        case 1:
            return (
                LinearGradient(colors: [.orange, .red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                "party.popper",
                90
            )
        case 2:
            return (
                LinearGradient(colors: [.green, .mint, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing),
                "guitars",
                95
            )
        case 3:
            return (
                LinearGradient(colors: [.purple, .indigo, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                "waveform",
                100
            )
        case 4:
            return (
                LinearGradient(colors: [.pink, .purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing),
                "music.mic",
                90
            )
        default:
            return (
                LinearGradient(colors: [.yellow, .orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing),
                "music.note.list",
                95
            )
        }
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
            // MEDIA - Imagen más grande (aproximadamente el doble) con tema único
            ZStack {
                eventTheme.gradient
                
                Image(systemName: eventTheme.icon)
                    .font(.system(size: eventTheme.iconSize, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .aspectRatio(4/3, contentMode: .fill)  // ✅ Proporción 4:3 consistente en todos los dispositivos
            .frame(maxWidth: .infinity)
            .clipped()
            
            // INFO SECTION - Debajo de la imagen (tipo Instagram)
            VStack(alignment: .leading, spacing: 12) {  // ✅ Spacing normal
                // Botones de acción con sistema glass nativo (botones a la izquierda)
                if #available(iOS 26.0, *) {
                    HStack(spacing: 12) {
                        HStack(spacing: 10) {
                            GlassIconButton(onSymbol: "heart.fill", offSymbol: "heart", isOn: $isLiked)
                            GlassIconButton(onSymbol: "bookmark.fill", offSymbol: "bookmark", isOn: $isSaved)
                            GlassIconButton(onSymbol: "square.and.arrow.up", offSymbol: nil, isOn: .constant(true)) { }
                        }
                        .fixedSize(horizontal: true, vertical: false)  // ✅ evita que se compriman/corten
                        
                        Button { } label: {
                            Label("Tickets", systemImage: "ticket")
                                .lineLimit(1)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.purple)
                        .frame(height: 44)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 28)  // ✅ Padding izquierdo aumentado para mover botones a la derecha
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                } else {
                    HStack(spacing: 12) {
                        ActionButtonsGroupFallback(isLiked: $isLiked, isSaved: $isSaved)
                            .fixedSize(horizontal: true, vertical: false)
                        ticketsButton
                        Spacer(minLength: 0)
                    }
                    .padding(.leading, 28)  // ✅ Padding izquierdo aumentado para mover botones a la derecha
                    .padding(.trailing, 16)
                    .padding(.top, 12)
                }
                
                // Título y descripción
                VStack(alignment: .leading, spacing: 6) {
                    Text("Evento \(eventNumber)")
                        .font(.system(size: 18, weight: .semibold))  // ✅ Tamaño normal para feed
                        .foregroundStyle(.white)
                        .lineLimit(1)
                    
                    Text("Música electrónica y buena vibra!")
                        .font(.system(size: 14))  // ✅ Tamaño normal para feed
                        .foregroundStyle(.white.opacity(0.9))
                        .lineLimit(3)
                }
                .padding(.leading, 32)  // ✅ Padding izquierdo aumentado para mover info a la derecha
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Fecha y ubicación
                HStack(spacing: 12) {
                    Label("Vie 15 Dic · 21:00", systemImage: "calendar")
                    Label("Club Nocturno", systemImage: "mappin.circle.fill")
                }
                .font(.system(size: 12))  // ✅ Tamaño normal para feed
                .foregroundStyle(.white.opacity(0.7))
                .padding(.leading, 32)  // ✅ Padding izquierdo aumentado para mover info a la derecha
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 24)  // ✅ Padding aumentado de 16 a 24
        }
        .padding(.horizontal, 16)  // ✅ Padding externo antes del clip
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
    
    // MARK: - Wide Card (Horizontal - Layout actual)
    private var wideCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                eventTheme.gradient
                Image(systemName: eventTheme.icon)
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
                
                if #available(iOS 26.0, *) {
                    HStack(spacing: 12) {
                        HStack(spacing: 10) {
                            GlassIconButton(onSymbol: "heart.fill", offSymbol: "heart", isOn: $isLiked)
                            GlassIconButton(onSymbol: "bookmark.fill", offSymbol: "bookmark", isOn: $isSaved)
                            GlassIconButton(onSymbol: "square.and.arrow.up", offSymbol: nil, isOn: .constant(true)) { }
                        }
                        .fixedSize(horizontal: true, vertical: false)  // ✅ evita que se compriman/corten
                        
                        Spacer(minLength: 0)
                        
                        Button { } label: {
                            Label("Tickets", systemImage: "ticket")
                                .lineLimit(1)
                        }
                        .buttonStyle(.glassProminent)
                        .tint(.purple)
                        .frame(height: 44)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                } else {
                    HStack(spacing: 12) {
                        ActionButtonsGroupFallback(isLiked: $isLiked, isSaved: $isSaved)
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer(minLength: 0)
                        ticketsButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                }
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

// MARK: - Glass Icon Button (idéntico al ejemplo LiquidGlassSwiftUI)

@available(iOS 26.0, *)
struct GlassIconButton: View {
    let onSymbol: String
    let offSymbol: String?
    @Binding var isOn: Bool
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            withAnimation(.bouncy(duration: 0.35)) {
                if offSymbol != nil {
                    isOn.toggle()
                }
                action?()
            }
        } label: {
            Image(systemName: isOn ? onSymbol : (offSymbol ?? onSymbol))
                .foregroundStyle(isOn && onSymbol == "heart.fill" ? .red : .white.opacity(0.9))
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 38, height: 38)  // ✅ Botones más pequeños
        }
        .buttonStyle(.glass)  // 🔥 EXACTO al ejemplo
        .buttonBorderShape(.circle)  // 🔥 EXACTO al ejemplo
        .symbolEffect(.bounce, value: isOn && onSymbol == "heart.fill")  // ✅ bounce solo en heart
    }
}

// Fallback para versiones anteriores a iOS 26
struct ActionButtonsGroupFallback: View {
    @Binding var isLiked: Bool
    @Binding var isSaved: Bool
    
    var body: some View {
        HStack(spacing: 6) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isLiked.toggle()
                }
            }) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .actionIcon(font: .system(size: 14))
                    .glassCircleButton(diameter: 32, tint: isLiked ? .red : .white)
            }
            
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isSaved.toggle()
                }
            }) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .actionIcon(font: .system(size: 14))
                    .glassCircleButton(diameter: 32, tint: .white)
            }
            
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
