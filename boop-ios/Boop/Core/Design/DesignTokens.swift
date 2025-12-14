import SwiftUI

/// Design System Tokens - Spacing y Tamaños unificados
/// Basado en Human Interface Guidelines con grid de 8pt

// MARK: - Spacing (grid de 8pt)
enum Spacing {
    static let xs: CGFloat = 4      // 0.5x base
    static let sm: CGFloat = 8      // 1x base
    static let md: CGFloat = 12     // 1.5x base
    static let lg: CGFloat = 16     // 2x base
    static let xl: CGFloat = 20     // 2.5x base
    static let xxl: CGFloat = 24    // 3x base
    static let xxxl: CGFloat = 32   // 4x base
}

// MARK: - Button Sizes
enum ButtonSize {
    /// Altura para botones primarios (Capsule)
    static let primaryHeight: CGFloat = 52
    
    /// Altura para botones secundarios
    static let secondaryHeight: CGFloat = 48
    
    /// Tamaño mínimo para icon buttons (HIG: 44x44)
    static let iconSize: CGFloat = 44
    
    /// Tamaño para icon buttons grandes
    static let iconSizeLarge: CGFloat = 56
    
    /// Padding horizontal para botones primarios
    static let primaryHorizontalPadding: CGFloat = 24
    
    /// Padding vertical para botones primarios
    static let primaryVerticalPadding: CGFloat = 16
}

// MARK: - Card Sizes
enum CardSize {
    /// Padding interno estándar para cards
    static let padding: CGFloat = 16
    
    /// Corner radius estándar para cards
    static let cornerRadius: CGFloat = 20
    
    /// Corner radius pequeño para cards
    static let cornerRadiusSmall: CGFloat = 16
    
    /// Corner radius para cards grandes/paneles
    static let cornerRadiusLarge: CGFloat = 24
}

// MARK: - Input Sizes
enum InputSize {
    /// Altura estándar para inputs (más compacta, consistente con diseño de tarjetas)
    static let height: CGFloat = 48
    
    /// Corner radius para inputs
    static let cornerRadius: CGFloat = 16
    
    /// Padding interno para inputs (reducido para consistencia con tarjetas)
    static let padding: CGFloat = 12
}

// MARK: - Grid Spacing
enum GridSpacing {
    /// Spacing entre items en grid de eventos
    static let eventGrid: CGFloat = 16
    
    /// Spacing entre secciones
    static let section: CGFloat = 24
}

// MARK: - Typography
enum Typography {
    /// Tamaño para títulos grandes
    static let largeTitle: CGFloat = 48
    
    /// Tamaño para títulos
    static let title: CGFloat = 28
    
    /// Tamaño para subtítulos
    static let subtitle: CGFloat = 16
    
    /// Tamaño para body
    static let body: CGFloat = 17
    
    /// Tamaño para caption
    static let caption: CGFloat = 14
}

