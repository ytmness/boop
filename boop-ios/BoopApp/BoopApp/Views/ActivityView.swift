//
//  ActivityView.swift
//  BoopApp
//
//  Activity feed - Notificaciones e interacciones
//

import SwiftUI

struct ActivityView: View {
    @State private var selectedFilter: ActivityFilter = .all
    
    enum ActivityFilter: String, CaseIterable {
        case all = "Todo"
        case likes = "Me gusta"
        case comments = "Comentarios"
        case follows = "Seguimientos"
        case events = "Eventos"
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                VStack(spacing: 0) {
                    // Filter tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ActivityFilter.allCases, id: \.self) { filter in
                                FilterChip(
                                    title: filter.rawValue,
                                    isSelected: selectedFilter == filter
                                ) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedFilter = filter
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    
                    // Activity feed
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(0..<10, id: \.self) { index in
                                ActivityItemCard(index: index)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    }
                }
            }
            .navigationTitle("Actividad")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

// MARK: - Filter Chip
private struct FilterChip: View {
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

// MARK: - Activity Item Card
private struct ActivityItemCard: View {
    let index: Int
    
    private var activityType: ActivityType {
        let types: [ActivityType] = [.like, .comment, .follow, .event]
        return types[index % types.count]
    }
    
    enum ActivityType {
        case like
        case comment
        case follow
        case event
        
        var icon: String {
            switch self {
            case .like: return "heart.fill"
            case .comment: return "message.fill"
            case .follow: return "person.badge.plus"
            case .event: return "calendar"
            }
        }
        
        var color: Color {
            switch self {
            case .like: return .red
            case .comment: return .blue
            case .follow: return .green
            case .event: return .purple
            }
        }
        
        var title: String {
            switch self {
            case .like: return "le dio me gusta a tu evento"
            case .comment: return "comentó en tu evento"
            case .follow: return "empezó a seguirte"
            case .event: return "creó un nuevo evento"
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            Circle()
                .fill(LinearGradient(
                    colors: [activityType.color, activityType.color.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: activityType.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                }
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("Usuario \(index + 1)")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)
                    
                    Text(activityType.title)
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.8))
                }
                
                Text("hace \(index + 1)h")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Spacer()
            
            // Action indicator
            if activityType == .event {
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.thinMaterial)
        }
    }
}

#Preview {
    ActivityView()
}

