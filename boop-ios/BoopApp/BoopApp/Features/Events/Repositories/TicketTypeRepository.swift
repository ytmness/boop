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
    
    func purchaseTickets(eventId: UUID, ticketTypeId: UUID, quantity: Int, userId: UUID) async throws -> PurchaseTicketsResult {
        guard let client = client else {
            throw NSError(domain: "TicketTypeRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        struct RPCParams: Codable {
            let pEventId: String
            let pTicketTypeId: String
            let pQuantity: Int
            let pUserId: String
            
            enum CodingKeys: String, CodingKey {
                case pEventId = "p_event_id"
                case pTicketTypeId = "p_ticket_type_id"
                case pQuantity = "p_quantity"
                case pUserId = "p_user_id"
            }
        }
        
        let params = RPCParams(
            pEventId: eventId.uuidString,
            pTicketTypeId: ticketTypeId.uuidString,
            pQuantity: quantity,
            pUserId: userId.uuidString
        )
        
        let result: PurchaseTicketsResult = try await client
            .rpc("purchase_tickets", params: params)
            .execute()
            .value
        
        return result
    }
}
