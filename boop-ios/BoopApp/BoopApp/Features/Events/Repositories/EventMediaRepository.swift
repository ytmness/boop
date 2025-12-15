//
//  EventMediaRepository.swift
//  BoopApp
//
//  Repositorio para operaciones de media de eventos
//

import Foundation
import Supabase

final class EventMediaRepository {
    private var client: SupabaseClient? {
        SupabaseConfig.shared.client
    }

    func fetchMedia(for eventId: UUID) async throws -> [EventMedia] {
        guard let client = client else {
            throw NSError(domain: "EventMediaRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let media: [EventMedia] = try await client
            .from("event_media")
            .select()
            .eq("event_id", value: eventId.uuidString)
            .order("sort_order", ascending: true)
            .execute()
            .value
        
        return media
    }

    func createMedia(payload: CreateEventMediaPayload) async throws -> EventMedia {
        guard let client = client else {
            throw NSError(domain: "EventMediaRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let inserted: [EventMedia] = try await client
            .from("event_media")
            .insert(payload)
            .select()
            .execute()
            .value

        guard let first = inserted.first else {
            throw NSError(domain: "EventMediaRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insert did not return row"])
        }
        return first
    }
    
    func deleteMedia(id: UUID) async throws {
        guard let client = client else {
            throw NSError(domain: "EventMediaRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        try await client
            .from("event_media")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
}
