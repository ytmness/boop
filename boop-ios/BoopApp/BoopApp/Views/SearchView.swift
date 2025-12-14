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
                    .frame(maxWidth: 400)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // Category selector
                    GeometryReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 0) {
                                Spacer(minLength: 0)
                                
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
                            }
                            // CLAVE: el contenedor mide al menos el ancho visible, y alinea trailing
                            .frame(minWidth: proxy.size.width, alignment: .trailing)
                            .padding(.trailing, 16)   // "más a la derecha"
                            .padding(.leading, 16)    // margen normal para que no pegue al borde
                            .padding(.vertical, 10)
                        }
                    }
                    .frame(height: 52)
                    
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
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .background {
            Group {
                if #available(iOS 26.0, *) {
                    Capsule()
                        .fill(Color.clear)
                        .glassEffect(.clear.interactive())
                } else {
                    ZStack {
                        Capsule().fill(.ultraThinMaterial)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isSelected ? 0.18 : 0.10),
                                        .clear
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Capsule()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [
                                        .white.opacity(isSelected ? 0.55 : 0.28),
                                        .white.opacity(isSelected ? 0.20 : 0.10)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                }
            }
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.28, dampingFraction: 0.78), value: isSelected)
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

