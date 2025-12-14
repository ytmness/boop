//
//  GlassField.swift
//  BoopApp
//
//  Campo de texto con estilo Liquid Glass
//

import SwiftUI

struct GlassField: View {
    let title: String
    @Binding var text: String
    var systemImage: String? = nil

    var body: some View {
        HStack(spacing: 10) {
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundStyle(.white.opacity(0.85))
                    .font(.system(size: 16))
            }
            TextField(title, text: $text)
                .textInputAutocapitalization(.sentences)
                .foregroundStyle(.white)
                .font(.system(size: 15))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 14, x: 0, y: 8)
    }
}
