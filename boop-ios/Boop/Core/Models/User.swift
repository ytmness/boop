import Foundation

/// Modelo de Usuario/Perfil
struct UserProfile: Identifiable, Codable {
    let id: UUID
    let userId: UUID
    let displayName: String?
    let avatarUrl: String?
    let bio: String?
    let city: String?
    let createdAt: Date
    let updatedAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case displayName = "display_name"
        case avatarUrl = "avatar_url"
        case bio
        case city
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

