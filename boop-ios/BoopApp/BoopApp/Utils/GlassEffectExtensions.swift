//
//  GlassEffectExtensions.swift
//  BoopApp
//
//  Extensions for easier Liquid Glass usage
//

import SwiftUI

// MARK: - Glass Effect Extensions

extension View {
    /// Apply glass effect to any view using ultraThinMaterial
    func glassEffect() -> some View {
        self.background(.ultraThinMaterial)
    }
}

