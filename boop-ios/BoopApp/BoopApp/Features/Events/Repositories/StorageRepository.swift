//
//  StorageRepository.swift
//  BoopApp
//
//  Repositorio para subir archivos a Supabase Storage
//

import Foundation
import Supabase
import UIKit

final class StorageRepository {
    private var client: SupabaseClient? {
        SupabaseConfig.shared.client
    }
    
    /// Sube una imagen al bucket event-media
    func uploadEventImage(eventId: UUID, imageData: Data, fileName: String) async throws -> String {
        guard let client = client else {
            throw NSError(domain: "StorageRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let filePath = "\(eventId.uuidString)/\(fileName)"
        
        try await client.storage
            .from("event-media")
            .upload(path: filePath, file: imageData, options: FileOptions(upsert: true))
        
        // Obtener URL pública
        let publicURL = try client.storage
            .from("event-media")
            .getPublicURL(path: filePath)
        
        return publicURL.absoluteString
    }
    
    /// Sube un video al bucket event-media
    func uploadEventVideo(eventId: UUID, videoData: Data, fileName: String) async throws -> String {
        guard let client = client else {
            throw NSError(domain: "StorageRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "Supabase client no configurado"])
        }
        
        let filePath = "\(eventId.uuidString)/\(fileName)"
        
        try await client.storage
            .from("event-media")
            .upload(path: filePath, file: videoData, options: FileOptions(upsert: true))
        
        // Obtener URL pública
        let publicURL = try client.storage
            .from("event-media")
            .getPublicURL(path: filePath)
        
        return publicURL.absoluteString
    }
    
    /// Genera un nombre de archivo único con extensión
    static func generateFileName(for data: Data, type: MediaType) -> String {
        let extension: String
        switch type {
        case .image:
            // Detectar tipo de imagen desde los primeros bytes
            if data.starts(with: [0xFF, 0xD8, 0xFF]) {
                extension = "jpg"
            } else if data.starts(with: [0x89, 0x50, 0x4E, 0x47]) {
                extension = "png"
            } else {
                extension = "jpg" // Default
            }
        case .video:
            extension = "mp4"
        }
        return "\(UUID().uuidString).\(extension)"
    }
}
