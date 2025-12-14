import SwiftUI

/// Pantalla de Crear Evento - Similar a Flutter
struct CreateEventView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var eventService = EventService()
    
    @State private var title = ""
    @State private var description = ""
    @State private var city = ""
    @State private var address = ""
    @State private var startDate = Date()
    @State private var endDate: Date?
    @State private var isPublic = false
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: GridSpacing.section) {
                    // Título
                    GlassTextField(
                        placeholder: "Título del evento",
                        text: $title
                    )
                    
                    // Descripción
                    GlassContainer(cornerRadius: CardSize.cornerRadiusSmall, padding: 0) {
                        TextField("Descripción", text: $description, axis: .vertical)
                            .foregroundStyle(.white)
                            .lineLimit(5...10)
                            .padding(CardSize.padding)
                    }
                    
                    // Ciudad
                    GlassTextField(
                        placeholder: "Ciudad",
                        text: $city
                    )
                    
                    // Dirección
                    GlassTextField(
                        placeholder: "Dirección (opcional)",
                        text: $address
                    )
                    
                    // Fecha de inicio
                    DatePicker(
                        "Fecha de inicio",
                        selection: $startDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .foregroundStyle(.white)
                    .boopGlassContainer(cornerRadius: CardSize.cornerRadiusSmall, padding: CardSize.padding)
                    
                    // Switch público
                    HStack {
                        Text("Evento público")
                            .foregroundStyle(.white)
                        Spacer()
                        Toggle("", isOn: $isPublic)
                            .tint(.white)
                    }
                    .boopGlassContainer(cornerRadius: CardSize.cornerRadiusSmall, padding: CardSize.padding)
                    
                    // Botón guardar
                    GlassButton(
                        title: "Guardar",
                        action: saveEvent,
                        isLoading: isLoading
                    )
                    // Liquid Glass: Padding inferior adicional para mejor espaciado
                    .padding(.bottom, Spacing.lg)
                }
                .padding(.horizontal, Spacing.lg)
                .padding(.top, Spacing.lg)
            }
        }
        .navigationTitle("Crear Evento")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let error = errorMessage {
                Text(error)
            }
        }
    }
    
    private func saveEvent() {
        guard !title.isEmpty else {
            errorMessage = "El título es requerido"
            return
        }
        
        guard let userId = authViewModel.currentUser?.id else {
            errorMessage = "Usuario no autenticado"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                _ = try await eventService.createEvent(
                    title: title,
                    description: description.isEmpty ? nil : description,
                    startTime: startDate,
                    endTime: endDate,
                    timezone: TimeZone.current.identifier,
                    city: city.isEmpty ? nil : city,
                    address: address.isEmpty ? nil : address,
                    latitude: nil,
                    longitude: nil,
                    imageUrl: nil,
                    communityId: nil,
                    createdBy: userId,
                    isPublic: isPublic
                )
                
                dismiss()
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        CreateEventView()
    }
}

