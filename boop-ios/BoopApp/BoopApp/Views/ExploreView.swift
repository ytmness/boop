//
//  ExploreView.swift
//  BoopApp
//
//

import SwiftUI

struct ExploreView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Search bar
                        SearchBar(
                            text: $searchText,
                            isFocused: $isSearchFocused
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle("Explora nuevos eventos!")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

// MARK: - Search Bar Component
private struct SearchBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
                .font(.system(size: 16))
            
            TextField("Buscar eventos...", text: $text)
                .foregroundStyle(.white)
                .font(.system(size: 15))
                .focused(isFocused)
        }
        .frame(height: 44)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(
                    isFocused.wrappedValue ? Color.white.opacity(0.3) : Color.white.opacity(0.1),
                    lineWidth: isFocused.wrappedValue ? 1.5 : 1
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused.wrappedValue)
    }
}

#Preview {
    ExploreView()
}
