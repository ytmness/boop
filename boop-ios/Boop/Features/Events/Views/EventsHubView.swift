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
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(events) { event in
                                EventCard(event: event)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Eventos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        CreateEventView()
                    } label: {
                        Image(systemName: "plus")
                            .boopGlassCircleButton(diameter: 44)
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
        GlassContainer(cornerRadius: 20, padding: 0) {
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
                
                // Contenido
                VStack(alignment: .leading, spacing: 8) {
                    Text(event.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                    
                    if let city = event.city {
                        Text(city)
                            .font(.system(size: 14))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    
                    Text(event.startTime, style: .date)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding()
            }
        }
    }
}

#Preview {
    EventsHubView()
}

