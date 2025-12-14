//
//  EventRow.swift
//  BoopApp
//
//  Modelo de datos para eventos desde Supabase
//

import Foundation

struct EventRow: Codable, Identifiable, Hashable {
    let id: UUID
    let communityId: UUID?
    let title: String
    let description: String?
    let startTime: Date
    let endTime: Date?
    let timezone: String?
    let city: String?
    let address: String?
    let lat: Double?
    let lng: Double?
    let imageUrl: String?
    let status: String
    let isPublic: Bool?
    let createdBy: UUID
    let viewsCount: Int?
    let createdAt: Date?
    let updatedAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case communityId = "community_id"
        case title
        case description
        case startTime = "start_time"
        case endTime = "end_time"
        case timezone
        case city
        case address
        case lat
        case lng
        case imageUrl = "image_url"
        case status
        case isPublic = "is_public"
        case createdBy = "created_by"
        case viewsCount = "views_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct CreateEventPayload: Codable {
    let communityId: UUID?
    let title: String
    let description: String?
    let startTime: Date
    let endTime: Date?
    let timezone: String?
    let city: String?
    let address: String?
    let lat: Double?
    let lng: Double?
    let imageUrl: String?
    let status: String
    let isPublic: Bool
    let createdBy: UUID

    enum CodingKeys: String, CodingKey {
        case communityId = "community_id"
        case title
        case description
        case startTime = "start_time"
        case endTime = "end_time"
        case timezone
        case city
        case address
        case lat
        case lng
        case imageUrl = "image_url"
        case status
        case isPublic = "is_public"
        case createdBy = "created_by"
    }
}
