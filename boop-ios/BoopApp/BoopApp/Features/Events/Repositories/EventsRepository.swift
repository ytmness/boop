//
//  EventsRepository.swift
//  BoopApp
//
//  Repositorio para operaciones de eventos con Supabase
//

import Foundation
import Supabase

final class EventsRepository {
    private var client: SupabaseClient? {
        SupabaseConfig.shared.client
    }

    func fetchEvents(limit: Int = 50) async throws -> [EventRow] {
        guard let client = client else {
            throw NSError(domain: "EventsRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let events: [EventRow] = try await client
            .from("events")
            .select()
            .order("start_time", ascending: false)
            .limit(limit)
            .execute()
            .value
        
        return events
    }
    
    /// Obtiene la primera imagen de un evento desde event_media
    func fetchFirstEventImage(eventId: UUID) async throws -> String? {
        guard let client = client else {
            throw NSError(domain: "EventsRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        struct EventMediaRow: Codable {
            let url: String
        }
        
        let media: [EventMediaRow] = try await client
            .from("event_media")
            .select("url")
            .eq("event_id", value: eventId.uuidString)
            .eq("type", value: "image")
            .order("sort_order", ascending: true)
            .limit(1)
            .execute()
            .value
        
        return media.first?.url
    }

    func createEvent(payload: CreateEventPayload) async throws -> EventRow {
        guard let client = client else {
            throw NSError(domain: "EventsRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let inserted: [EventRow] = try await client
            .from("events")
            .insert(payload)
            .select()
            .execute()
            .value

        guard let first = inserted.first else {
            throw NSError(domain: "EventsRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insert did not return row"])
        }
        return first
    }
}
