//
//  SearchView.swift
//  BoopApp
//
//  Search view - Liquid Glass iOS 26
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    @State private var selectedCategory: SearchCategory = .events
    
    enum SearchCategory: String, CaseIterable {
        case events = "Eventos"
        case users = "Usuarios"
        case communities = "Comunidades"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                VStack(spacing: 0) {
                    
                    // ✅ SEARCH BAR — MÁS PEQUEÑO Y CENTRADO
                    LiquidGlassSearchBar(
                        text: $searchText,
                        isFocused: $isSearchFocused
                    )
                    .frame(maxWidth: 340) // ⬅️ MÁS ANGOSTO
                    .padding(.top, 10)
                    
                    // ✅ CATEGORY SELECTOR
                    GeometryReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(SearchCategory.allCases, id: \.self) { category in
                                    GlassCategoryChip(
                                        title: category.rawValue,
                                        isSelected: selectedCategory == category
                                    ) {
                                        withAnimation(.spring(response: 0.28, dampingFraction: 0.78)) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                            .frame(minWidth: proxy.size.width, alignment: .center)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                        }
                    }
                    .frame(height: 52)
                    
                    // ✅ CONTENT
                    ScrollView {
                        if searchText.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 44))
                                    .foregroundStyle(.white.opacity(0.45))
                                
                                Text("Busca eventos, usuarios\n o comunidades")
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 100)
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(0..<5, id: \.self) { index in
                                    SearchResultCard(
                                        category: selectedCategory,
                                        index: index
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                        }
                    }
                }
            }
            .navigationTitle("Buscar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

// MARK: - Liquid Glass Search Bar
private struct LiquidGlassSearchBar: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
                .font(.system(size: 16))
            
            TextField("Buscar", text: $text)
                .foregroundStyle(.white)
                .font(.system(size: 15))
                .focused($isFocused)
        }
        .padding(.horizontal, 14)
        .frame(height: 46)
        .background {
            if #available(iOS 26.0, *) {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.clear)
                    .glassEffect(.clear.interactive())
            } else {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.ultraThinMaterial)
            }
        }
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    Color.white.opacity(isFocused ? 0.35 : 0.15),
                    lineWidth: isFocused ? 1.5 : 1
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isFocused)
    }
}

// MARK: - Glass Category Chip
private struct GlassCategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(isSelected ? 1.0 : 0.85))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
        .background {
            if #available(iOS 26.0, *) {
                Capsule()
                    .fill(Color.clear)
                    .glassEffect(.clear.interactive())
            } else {
                Capsule()
                    .fill(.ultraThinMaterial)
            }
        }
        .scaleEffect(isSelected ? 1.03 : 1.0)
        .animation(.spring(response: 0.28, dampingFraction: 0.78), value: isSelected)
    }
}

// MARK: - Search Result Card
private struct SearchResultCard: View {
    let category: SearchView.SearchCategory
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(category.rawValue) \(index + 1)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.7))
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
        }
    }
    
    private var iconName: String {
        switch category {
        case .events: return "calendar"
        case .users: return "person.circle"
        case .communities: return "person.3"
        }
    }
    
    private var description: String {
        switch category {
        case .events: return "Evento de música electrónica"
        case .users: return "@usuario\(index + 1)"
        case .communities: return "Comunidad de eventos"
        }
    }
}

#Preview {
    SearchView()
}
