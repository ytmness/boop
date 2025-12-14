import Foundation

/// Modelo de Evento - Misma estructura que Flutter
struct Event: Identifiable, Codable {
    let id: UUID
    let communityId: UUID?
    let title: String
    let description: String?
    let startTime: Date
    let endTime: Date?
    let timezone: String?
    let city: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let imageUrl: String?
    let status: String // draft, published, past
    let isPublic: Bool
    let createdBy: UUID
    let createdAt: Date
    let updatedAt: Date?
    let viewsCount: Int
    let interestedCount: Int?
    
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
        case latitude = "lat"
        case longitude = "lng"
        case imageUrl = "image_url"
        case status
        case isPublic = "is_public"
        case createdBy = "created_by"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case viewsCount = "views_count"
        case interestedCount = "interested_count"
    }
    
    var isPast: Bool {
        if let endTime = endTime {
            return endTime < Date()
        }
        return startTime < Date()
    }
    
    var isUpcoming: Bool {
        return !isPast && startTime > Date()
    }
}

