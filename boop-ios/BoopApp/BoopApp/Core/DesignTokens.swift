//
//  DesignTokens.swift
//  BoopApp
//
//  Design System Tokens - Valores centralizados
//

import SwiftUI

/// Design Tokens para mantener consistencia en toda la app
enum DesignTokens {
    
    // MARK: - Spacing
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        
        /// Padding horizontal estándar para contenido
        static let contentHorizontal: CGFloat = 16
        
        /// Spacing entre cards en feeds
        static let betweenCards: CGFloat = 16
    }
    
    // MARK: - Corner Radius
    enum CornerRadius {
        static let sm: CGFloat = 12
        static let md: CGFloat = 16
        static let lg: CGFloat = 20
        static let xl: CGFloat = 24
        
        /// Corner radius para cards principales
        static let card: CGFloat = 20
        
        /// Corner radius para botones
        static let button: CGFloat = 16
    }
    
    // MARK: - Button Sizes
    enum ButtonSize {
        static let primaryHeight: CGFloat = 52
        static let secondaryHeight: CGFloat = 44
        static let compactHeight: CGFloat = 32
        
        /// Tamaño para botones circulares de acción
        static let circleActionDiameter: CGFloat = 44
    }
    
    // MARK: - Card Dimensions
    enum CardSize {
        /// Aspect ratio para imágenes de eventos (ancho:alto)
        /// 3:2 = proporción más cuadrada, mejor para móvil
        static let eventImageAspectRatio: CGFloat = 3/2
        
        /// Padding interno de cards
        static let padding: CGFloat = 12
        
        /// Altura mínima para cards de evento (reducida)
        static let minHeight: CGFloat = 240
    }
    
    // MARK: - Typography
    enum Typography {
        static let titleLarge: CGFloat = 22
        static let title: CGFloat = 18
        static let subtitle: CGFloat = 15
        static let body: CGFloat = 14
        static let caption: CGFloat = 11
        static let small: CGFloat = 10
    }
    
    // MARK: - Safe Area
    /// Estimación de altura del tab bar nativo (puede variar según dispositivo)
    /// Se calcula dinámicamente en runtime cuando sea posible
    static let estimatedTabBarHeight: CGFloat = 83 // 49 bar + 34 safe area
}

