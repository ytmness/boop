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
