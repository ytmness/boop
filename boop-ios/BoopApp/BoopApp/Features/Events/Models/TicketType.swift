//
//  TicketType.swift
//  BoopApp
//
//  Modelo para tipos de boletos (zonas)
//

import Foundation

struct TicketType: Codable, Identifiable, Hashable {
    let id: UUID
    let eventId: UUID
    let name: String
    let price: Double
    let currency: String
    let quantityTotal: Int
    let quantitySold: Int
    let maxPerUser: Int?
    let salesStart: Date?
    let salesEnd: Date?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case name
        case price
        case currency
        case quantityTotal = "quantity_total"
        case quantitySold = "quantity_sold"
        case maxPerUser = "max_per_user"
        case salesStart = "sales_start"
        case salesEnd = "sales_end"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var availableQuantity: Int {
        quantityTotal - quantitySold
    }
    
    var isAvailable: Bool {
        availableQuantity > 0
    }
}

struct CreateTicketTypePayload: Codable {
    let eventId: UUID
    let name: String
    let price: Double
    let currency: String
    let quantityTotal: Int
    let maxPerUser: Int?
    let salesStart: Date?
    let salesEnd: Date?

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case name
        case price
        case currency
        case quantityTotal = "quantity_total"
        case maxPerUser = "max_per_user"
        case salesStart = "sales_start"
        case salesEnd = "sales_end"
    }
}
