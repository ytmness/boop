//
//  EventMedia.swift
//  BoopApp
//
//  Modelo para media (fotos/videos) de eventos
//

import Foundation

struct EventMedia: Codable, Identifiable, Hashable {
    let id: UUID
    let eventId: UUID
    let type: MediaType
    let url: String
    let thumbnailUrl: String?
    let sortOrder: Int
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case eventId = "event_id"
        case type
        case url
        case thumbnailUrl = "thumbnail_url"
        case sortOrder = "sort_order"
        case createdAt = "created_at"
    }
}

enum MediaType: String, Codable {
    case image = "image"
    case video = "video"
}

struct CreateEventMediaPayload: Codable {
    let eventId: UUID
    let type: String
    let url: String
    let thumbnailUrl: String?
    let sortOrder: Int

    enum CodingKeys: String, CodingKey {
        case eventId = "event_id"
        case type
        case url
        case thumbnailUrl = "thumbnail_url"
        case sortOrder = "sort_order"
    }
}
