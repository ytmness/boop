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

    @State private var isSaving = false
    @State private var errorMessage: String?

    private let repo = EventsRepository()

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
            onCreated(created)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error al crear evento: \(error.localizedDescription)")
        }
    }
}

#Preview {
    MainTabView(authViewModel: AuthViewModel())
}
