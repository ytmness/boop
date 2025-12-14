import SwiftUI

/// Pantalla principal de Eventos - Grid con cards glass
struct EventsHubView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var events: [Event] = []
    @State private var isLoading = false
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    ScrollView {
                        // Liquid Glass: GlassEffectContainer para agrupar eventos
                        if #available(iOS 26.0, *) {
                            GlassEffectContainer(spacing: GridSpacing.eventGrid) {
                                LazyVGrid(columns: columns, spacing: GridSpacing.eventGrid) {
                                    ForEach(events) { event in
                                        EventCard(event: event)
                                    }
                                }
                                .padding(.horizontal, Spacing.lg)
                                .padding(.top, Spacing.lg)
                                // Liquid Glass: Extender contenido debajo de la tab bar
                                .padding(.bottom, Spacing.xxxl)
                            }
                        } else {
                            LazyVGrid(columns: columns, spacing: GridSpacing.eventGrid) {
                                ForEach(events) { event in
                                    EventCard(event: event)
                                }
                            }
                            .padding(.horizontal, Spacing.lg)
                            .padding(.top, Spacing.lg)
                            .padding(.bottom, Spacing.xxxl)
                        }
                    }
                    // Liquid Glass: Asegurar que el scroll view se extienda debajo de la tab bar
                    .ignoresSafeArea(.container, edges: .bottom)
                }
            }
            .navigationTitle("Eventos")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // En iOS 26+, el botón principal está en tabViewBottomAccessory
                    // Este botón de toolbar es opcional o puede usarse para otra acción
                    if #available(iOS 26.0, *) {
                        // Opcional: mantener un botón de toolbar con estilo glass
                        Button(action: {
                            // Acción alternativa si se necesita
                        }) {
                            Image(systemName: "magnifyingglass")
                        }
                        .buttonStyle(.glass)
                        .controlSize(.regular)
                    } else {
                        // Fallback: botón para crear evento en versiones anteriores
                        NavigationLink {
                            CreateEventView()
                        } label: {
                            Image(systemName: "plus")
                                .boopGlassCircleButton(diameter: 44)
                        }
                    }
                }
            }
        }
        .task {
            await loadEvents()
        }
    }
    
    private func loadEvents() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let service = EventService()
            events = try await service.fetchEvents()
        } catch {
            print("Error al cargar eventos: \(error)")
        }
    }
}

// MARK: - Event Card
struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Imagen
            if let imageUrl = event.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 150)
                .clipped()
            } else {
                Color.gray.opacity(0.3)
                    .frame(height: 150)
            }
            
            // Contenido con padding mejorado
            VStack(alignment: .leading, spacing: Spacing.sm) {
                Text(event.title)
                    .font(.system(size: Typography.body, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                if let city = event.city {
                    Text(city)
                        .font(.system(size: Typography.caption))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Text(event.startTime, style: .date)
                    .font(.system(size: Typography.caption - 2))
                    .foregroundStyle(.white.opacity(0.6))
            }
            // Liquid Glass: Padding interno suficiente para evitar aspecto comprimido
            .padding(.horizontal, Spacing.lg)
            .padding(.vertical, Spacing.md)
        }
        // Liquid Glass: Aplicar glassEffect directamente al contenedor del evento
        .background {
            if #available(iOS 26.0, *) {
                RoundedRectangle(cornerRadius: CardSize.cornerRadius)
                    .fill(Color.clear)
                    .glassEffect(.regular)
            } else {
                RoundedRectangle(cornerRadius: CardSize.cornerRadius)
                    .fill(.ultraThinMaterial)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: CardSize.cornerRadius))
    }
}

#Preview {
    EventsHubView()
}

