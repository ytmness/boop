import Foundation
import Supabase

/// Servicio de Eventos - Misma lógica que Flutter
class EventService {
    private let supabase = SupabaseConfig.shared.client
    
    // MARK: - Obtener Eventos
    func fetchEvents(city: String? = nil) async throws -> [Event] {
        guard let supabase = supabase else {
            throw EventError.supabaseNotConfigured
        }
        
        var query = supabase
            .from("events")
            .select()
            .eq("status", value: "published")
            .order("start_time", ascending: false)
        
        if let city = city {
            query = query.eq("city", value: city)
        }
        
        let response: [Event] = try await query.execute().value
        return response
    }
    
    // MARK: - Crear Evento
    func createEvent(
        title: String,
        description: String?,
        startTime: Date,
        endTime: Date?,
        timezone: String?,
        city: String?,
        address: String?,
        latitude: Double?,
        longitude: Double?,
        imageUrl: String?,
        communityId: UUID?,
        createdBy: UUID,
        isPublic: Bool = false
    ) async throws -> Event {
        guard let supabase = supabase else {
            throw EventError.supabaseNotConfigured
        }
        
        let formatter = ISO8601DateFormatter()
        
        var eventData: [String: Any] = [
            "title": title,
            "start_time": formatter.string(from: startTime),
            "created_by": createdBy.uuidString,
            "status": isPublic ? "published" : "draft",
            "is_public": isPublic
        ]
        
        if let description = description {
            eventData["description"] = description
        }
        if let endTime = endTime {
            eventData["end_time"] = formatter.string(from: endTime)
        }
        if let timezone = timezone {
            eventData["timezone"] = timezone
        }
        if let city = city {
            eventData["city"] = city
        }
        if let address = address {
            eventData["address"] = address
        }
        if let latitude = latitude {
            eventData["lat"] = latitude
        }
        if let longitude = longitude {
            eventData["lng"] = longitude
        }
        if let imageUrl = imageUrl {
            eventData["image_url"] = imageUrl
        }
        if let communityId = communityId {
            eventData["community_id"] = communityId.uuidString
        }
        
        let response: [Event] = try await supabase
            .from("events")
            .insert(eventData)
            .select()
            .execute()
            .value
        
        guard let event = response.first else {
            throw EventError.creationFailed
        }
        
        return event
    }
}

enum EventError: LocalizedError {
    case supabaseNotConfigured
    case creationFailed
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .supabaseNotConfigured:
            return "Supabase no está configurado"
        case .creationFailed:
            return "Error al crear el evento"
        case .notFound:
            return "Evento no encontrado"
        }
    }
}

