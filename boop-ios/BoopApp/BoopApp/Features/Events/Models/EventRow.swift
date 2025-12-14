//
//  EventRow.swift
//  BoopApp
//
//  Modelo de datos para eventos desde Supabase
//

import Foundation

struct EventRow: Codable, Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String?
    let city: String?
    let venue: String?
    let startsAt: Date
    let coverUrl: String?
    let createdBy: UUID
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id, title, description, city, venue
        case startsAt = "starts_at"
        case coverUrl = "cover_url"
        case createdBy = "created_by"
        case createdAt = "created_at"
    }
}

struct CreateEventPayload: Codable {
    let title: String
    let description: String?
    let city: String?
    let venue: String?
    let startsAt: Date
    let coverUrl: String?
    let createdBy: UUID

    enum CodingKeys: String, CodingKey {
        case title, description, city, venue
        case startsAt = "starts_at"
        case coverUrl = "cover_url"
        case createdBy = "created_by"
    }
}
