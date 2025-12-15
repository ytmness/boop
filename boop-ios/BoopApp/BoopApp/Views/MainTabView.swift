//
//  MainTabView.swift
//  BoopApp
//
//  Main navigation with Liquid Glass Tab Bar
//

import SwiftUI
import PhotosUI

struct MainTabView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var selectedTab = 0
    @State private var showCreateEvent = false
    @State private var eventsViewModel = EventsViewModel()
    
    private var currentUserId: UUID? {
        authViewModel.currentUser?.id
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            EventsHubView(viewModel: eventsViewModel)
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
            if let userId = currentUserId {
                CreateEventView(
                    currentUserId: userId,
                    onCreated: { event in
                        Task { @MainActor in
                            eventsViewModel.addToTop(event)
                        }
                    }
                )
            } else {
                VStack {
                    Text("Debes iniciar sesión para crear eventos")
                        .foregroundStyle(.white)
                    Button("Cerrar") {
                        showCreateEvent = false
                    }
                    .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(GlassAnimatedBackground())
            }
        }
    }
}

// Vista para crear eventos con formulario Liquid Glass
struct CreateEventView: View {
    @Environment(\.dismiss) private var dismiss
    let currentUserId: UUID
    let onCreated: (EventRow) -> Void

    @State private var title = ""
    @State private var description = ""
    @State private var city = ""
    @State private var venue = ""
    @State private var startsAt = Date().addingTimeInterval(3600)
    
    // Media (fotos/videos)
    @State private var selectedMedia: [MediaItem] = []
    @State private var showMediaPicker = false
    
    // Ticket Types (zonas de boletos)
    @State private var ticketTypes: [TicketTypeForm] = []
    @State private var showTicketTypeEditor = false

    @State private var isSaving = false
    @State private var errorMessage: String?

    private let repo = EventsRepository()
    private let mediaRepo = EventMediaRepository()
    private let ticketRepo = TicketTypeRepository()
    
    // Modelo temporal para formulario de ticket type
    struct TicketTypeForm: Identifiable {
        let id = UUID()
        var name: String = ""
        var price: String = ""
        var quantity: String = ""
        var maxPerUser: String = ""
        var currency: String = "MXN"
    }
    
    // Modelo temporal para media seleccionado
    struct MediaItem: Identifiable {
        let id = UUID()
        let type: MediaType
        let url: String
        let thumbnailUrl: String?
        let data: Data?  // Datos de la imagen/video para subir
        let fileName: String?  // Nombre del archivo para Storage
    }

    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                ScrollView {
                    VStack(spacing: 14) {
                        Text("Crear evento")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .padding(.top, 10)

                        GlassField(title: "Título", text: $title, systemImage: "sparkles")
                        GlassField(title: "Descripción", text: $description, systemImage: "text.alignleft")
                        GlassField(title: "Ciudad", text: $city, systemImage: "mappin.and.ellipse")
                        GlassField(title: "Lugar / Dirección", text: $venue, systemImage: "building.2")
                        
                        // Sección Media (fotos/videos)
                        MediaSectionView(selectedMedia: $selectedMedia, showPicker: $showMediaPicker)
                        
                        // Sección Boletos (zonas)
                        TicketTypesSectionView(ticketTypes: $ticketTypes, showEditor: $showTicketTypeEditor)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundStyle(.white.opacity(0.85))
                                Text("Fecha y hora")
                                    .foregroundStyle(.white.opacity(0.9))
                                    .font(.system(size: 14, weight: .semibold))
                            }

                            DatePicker("", selection: $startsAt, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .tint(.white)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )

                        if let errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red.opacity(0.9))
                                .font(.system(size: 13))
                                .padding(.top, 6)
                        }

                        Button {
                            Task { await save() }
                        } label: {
                            HStack(spacing: 10) {
                                if isSaving { 
                                    ProgressView().tint(.white) 
                                }
                                Text(isSaving ? "Guardando..." : "Publicar")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .foregroundStyle(.white)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(.white.opacity(0.22), lineWidth: 1)
                            )
                        }
                        .disabled(isSaving || title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 18)
                }
                .scrollIndicators(.hidden)
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

    @MainActor
    private func save() async {
        errorMessage = nil
        isSaving = true
        defer { isSaving = false }

        do {
            let payload = CreateEventPayload(
                communityId: nil,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                description: description.isEmpty ? nil : description,
                startTime: startsAt,
                endTime: nil,
                timezone: TimeZone.current.identifier,
                city: city.isEmpty ? nil : city,
                address: venue.isEmpty ? nil : venue,
                lat: nil,
                lng: nil,
                imageUrl: nil,
                status: "draft",
                isPublic: false,
                createdBy: currentUserId
            )

            let created = try await repo.createEvent(payload: payload)
            
            // Subir media a Storage y crear registros en event_media
            let storageRepo = StorageRepository()
            for (index, media) in selectedMedia.enumerated() {
                guard let data = media.data, let fileName = media.fileName else { continue }
                
                // Subir a Storage
                let storageUrl: String
                if media.type == .image {
                    storageUrl = try await storageRepo.uploadEventImage(
                        eventId: created.id,
                        imageData: data,
                        fileName: fileName
                    )
                } else {
                    storageUrl = try await storageRepo.uploadEventVideo(
                        eventId: created.id,
                        videoData: data,
                        fileName: fileName
                    )
                }
                
                // Crear registro en event_media
                let mediaPayload = CreateEventMediaPayload(
                    eventId: created.id,
                    type: media.type.rawValue,
                    url: storageUrl,
                    thumbnailUrl: nil,
                    sortOrder: index
                )
                _ = try await mediaRepo.createMedia(payload: mediaPayload)
            }
            
            // Crear ticket types si hay definidos
            for ticketType in ticketTypes {
                guard let price = Double(ticketType.price),
                      let quantity = Int(ticketType.quantity),
                      !ticketType.name.isEmpty,
                      price > 0,
                      quantity > 0 else { continue }
                
                let ticketPayload = CreateTicketTypePayload(
                    eventId: created.id,
                    name: ticketType.name,
                    price: price,
                    currency: ticketType.currency,
                    quantityTotal: quantity,
                    maxPerUser: ticketType.maxPerUser.isEmpty ? nil : Int(ticketType.maxPerUser),
                    salesStart: nil,
                    salesEnd: nil
                )
                _ = try await ticketRepo.createTicketType(payload: ticketPayload)
            }
            
            onCreated(created)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error al crear evento: \(error.localizedDescription)")
        }
    }
}

// MARK: - Media Section View
private struct MediaSectionView: View {
    @Binding var selectedMedia: [CreateEventView.MediaItem]
    @Binding var showPicker: Bool
    @State private var selectedPhotos: [PhotosPickerItem] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "photo.on.rectangle")
                    .foregroundStyle(.white.opacity(0.85))
                Text("Fotos y videos")
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
            
            if selectedMedia.isEmpty {
                Button {
                    showPicker = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Agregar media")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white.opacity(0.18), lineWidth: 1)
                    )
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(selectedMedia) { media in
                            ZStack(alignment: .topTrailing) {
                                Group {
                                    if let data = media.data, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(.ultraThinMaterial)
                                            .overlay(
                                                Image(systemName: media.type == .image ? "photo" : "video.fill")
                                                    .foregroundStyle(.white.opacity(0.6))
                                            )
                                    }
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                
                                Button {
                                    selectedMedia.removeAll { $0.id == media.id }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.red)
                                        .background(.white, in: Circle())
                                }
                                .padding(4)
                            }
                        }
                        
                        Button {
                            showPicker = true
                        } label: {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.ultraThinMaterial)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Image(systemName: "plus")
                                        .foregroundStyle(.white.opacity(0.6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(.white.opacity(0.18), lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
        .photosPicker(isPresented: $showPicker, selection: $selectedPhotos, maxSelectionCount: 10, matching: .any(of: [.images, .videos]))
        .onChange(of: selectedPhotos) { _, newItems in
            Task {
                let storageRepo = StorageRepository()
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        // Detectar tipo de media
                        let mediaType: MediaType = item.supportedContentTypes.first?.conforms(to: .movie) == true ? .video : .image
                        
                        // Generar nombre de archivo temporal (se subirá cuando se cree el evento)
                        let tempId = UUID()
                        let fileName = StorageRepository.generateFileName(for: data, type: mediaType)
                        
                        // Guardar datos temporalmente (se subirá en save())
                        let mediaItem = CreateEventView.MediaItem(
                            type: mediaType,
                            url: "temp://\(tempId.uuidString)",
                            thumbnailUrl: nil,
                            data: data,
                            fileName: fileName
                        )
                        selectedMedia.append(mediaItem)
                    }
                }
                // Limpiar selección para permitir seleccionar más
                selectedPhotos = []
            }
        }
    }
}

// MARK: - Ticket Types Section View
private struct TicketTypesSectionView: View {
    @Binding var ticketTypes: [CreateEventView.TicketTypeForm]
    @Binding var showEditor: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "ticket.fill")
                    .foregroundStyle(.white.opacity(0.85))
                Text("Zonas de boletos")
                    .foregroundStyle(.white.opacity(0.9))
                    .font(.system(size: 14, weight: .semibold))
                Spacer()
            }
            
            if ticketTypes.isEmpty {
                Button {
                    ticketTypes.append(CreateEventView.TicketTypeForm())
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Agregar zona")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white.opacity(0.18), lineWidth: 1)
                    )
                }
            } else {
                VStack(spacing: 10) {
                    ForEach(ticketTypes.indices, id: \.self) { index in
                        TicketTypeRowView(ticketType: $ticketTypes[index], onDelete: {
                            ticketTypes.remove(at: index)
                        })
                    }
                    
                    Button {
                        ticketTypes.append(CreateEventView.TicketTypeForm())
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Agregar otra zona")
                        }
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                    }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
    }
}

// MARK: - Ticket Type Row View
private struct TicketTypeRowView: View {
    @Binding var ticketType: CreateEventView.TicketTypeForm
    let onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Zona")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white.opacity(0.7))
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundStyle(.red.opacity(0.8))
                        .font(.system(size: 12))
                }
            }
            
            GlassField(title: "Nombre (ej: General, VIP)", text: $ticketType.name, systemImage: "tag")
            GlassField(title: "Precio", text: $ticketType.price, systemImage: "dollarsign.circle")
                .keyboardType(.decimalPad)
            GlassField(title: "Cantidad total", text: $ticketType.quantity, systemImage: "number")
                .keyboardType(.numberPad)
            GlassField(title: "Máx por usuario (opcional)", text: $ticketType.maxPerUser, systemImage: "person.2")
                .keyboardType(.numberPad)
        }
        .padding(12)
        .background(.ultraThinMaterial.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}
