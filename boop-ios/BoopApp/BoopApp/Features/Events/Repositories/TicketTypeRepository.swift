//
//  TicketTypeRepository.swift
//  BoopApp
//
//  Repositorio para operaciones de tipos de boletos
//

import Foundation
import Supabase

final class TicketTypeRepository {
    private var client: SupabaseClient? {
        SupabaseConfig.shared.client
    }

    func fetchTicketTypes(for eventId: UUID) async throws -> [TicketType] {
        guard let client = client else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let ticketTypes: [TicketType] = try await client
            .from("ticket_types")
            .select()
            .eq("event_id", value: eventId.uuidString)
            .order("price", ascending: true)
            .execute()
            .value
        
        return ticketTypes
    }

    func createTicketType(payload: CreateTicketTypePayload) async throws -> TicketType {
        guard let client = client else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let inserted: [TicketType] = try await client
            .from("ticket_types")
            .insert(payload)
            .select()
            .execute()
            .value

        guard let first = inserted.first else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Insert did not return row"])
        }
        return first
    }
    
    func updateTicketType(id: UUID, payload: CreateTicketTypePayload) async throws -> TicketType {
        guard let client = client else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let updated: [TicketType] = try await client
            .from("ticket_types")
            .update(payload)
            .eq("id", value: id.uuidString)
            .select()
            .execute()
            .value

        guard let first = updated.first else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Update did not return row"])
        }
        return first
    }
    
    func deleteTicketType(id: UUID) async throws {
        guard let client = client else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        try await client
            .from("ticket_types")
            .delete()
            .eq("id", value: id.uuidString)
            .execute()
    }
    
    func purchaseTickets(eventId: UUID, ticketTypeId: UUID, quantity: Int, userId: UUID) async throws -> [String: Any] {
        guard let client = client else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let result: [String: Any] = try await client
            .rpc("purchase_tickets", params: [
                "p_event_id": eventId.uuidString,
                "p_ticket_type_id": ticketTypeId.uuidString,
                "p_quantity": quantity,
                "p_user_id": userId.uuidString
            ])
            .execute()
            .value
        
        return result
    }
}
