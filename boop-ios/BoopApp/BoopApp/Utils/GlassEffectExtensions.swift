//
//  GlassEffectExtensions.swift
//  BoopApp
//
//  Extensions for Liquid Glass (patrón oficial de Apple)
//

import SwiftUI

// MARK: - Liquid Glass Extensions (patrón del ejemplo oficial)

extension View {
    /// Botón circular con Liquid Glass REAL (sin overlays, gradientes ni strokes)
    func glassCircleButton(diameter: CGFloat = 64, tint: Color = .white) -> some View {
        self
            .foregroundStyle(tint)
            .frame(width: diameter, height: diameter)
            .contentShape(Circle())
            .background {
                if #available(iOS 26.0, *) {
                    Color.clear
                        .glassEffect(.clear.interactive())
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(.ultraThinMaterial)
                }
            }
    }
    
    /// Icono de acción con transición de símbolo
    func actionIcon(font: Font = .title2) -> some View {
        self
            .font(font)
            .contentTransition(.symbolEffect(.replace))
    }
}

// MARK: - GlassEffectContainer para agrupar botones

@available(iOS 26.0, *)
struct GlassEffectContainer<Content: View>: View {
    let spacing: CGFloat
    let content: Content
    
    init(spacing: CGFloat = 20, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            content
        }
    }
}
