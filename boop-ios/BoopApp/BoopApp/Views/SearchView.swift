//
//  SearchView.swift
//  BoopApp
//
//  Search view - Búsqueda de eventos, usuarios y comunidades
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
                    // Search bar
                    SearchBar(
                        text: $searchText,
                        isFocused: $isSearchFocused
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Category selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SearchCategory.allCases, id: \.self) { category in
                                CategoryChip(
                                    title: category.rawValue,
                                    isSelected: selectedCategory == category
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedCategory = category
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // Results
                    ScrollView {
                        if searchText.isEmpty {
                            // Empty state
                            VStack(spacing: 16) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 48))
                                    .foregroundStyle(.white.opacity(0.5))
                                
                                Text("Busca eventos, usuarios o comunidades")
                                    .font(.headline)
                                    .foregroundStyle(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 80)
                        } else {
                            // Search results placeholder
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
            
            TextField("Buscar...", text: $text)
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

// MARK: - Category Chip
private struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(isSelected ? .black : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(isSelected ? .white : .white.opacity(0.2))
                }
        }
    }
}

// MARK: - Search Result Card
private struct SearchResultCard: View {
    let category: SearchView.SearchCategory
    let index: Int
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon/Image
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
            
            // Content
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

