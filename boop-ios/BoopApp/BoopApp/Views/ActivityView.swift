//
//  ActivityView.swift
//  BoopApp
//
//  Activity feed - Infinite Carousel + Liquid Glass iOS 26
//

import SwiftUI
import UIKit

struct ActivityView: View {

    // ✅ Persistencia del filtro
    @AppStorage("activity.selected.filter")
    private var storedFilter: String = ActivityFilter.all.rawValue

    @State private var selectedFilter: ActivityFilter = .all
    @State private var chipCenters: [Int: CGFloat] = [:]
    @State private var didInitialScroll = false

    enum ActivityFilter: String, CaseIterable {
        case all = "Todo"
        case likes = "Me gusta"
        case comments = "Comentarios"
        case follows = "Seguimientos"
        case events = "Eventos"
    }

    // MARK: - Modelo de actividad
    struct ActivityItem: Identifiable {
        let id = UUID()
        let userName: String
        let type: ActivityFilter
        let time: String
    }

    // ✅ Datos mock (luego vendrán del backend)
    private let allItems: [ActivityItem] = [
        .init(userName: "Ana", type: .likes, time: "1h"),
        .init(userName: "Luis", type: .comments, time: "2h"),
        .init(userName: "María", type: .follows, time: "3h"),
        .init(userName: "Carlos", type: .events, time: "5h"),
        .init(userName: "Sofía", type: .likes, time: "6h"),
        .init(userName: "Diego", type: .comments, time: "8h"),
        .init(userName: "Lucía", type: .events, time: "1d")
    ]

    // 🔁 Filtro activo
    private var filteredItems: [ActivityItem] {
        guard selectedFilter != .all else { return allItems }
        return allItems.filter { $0.type == selectedFilter }
    }

    // 🔁 Lista triplicada para carrusel infinito
    private let baseFilters = ActivityFilter.allCases
    private var loopedFilters: [ActivityFilter] {
        baseFilters + baseFilters + baseFilters
    }

    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()

                VStack(spacing: 0) {

                    // ✅ CARRUSEL INFINITO (SE QUEDA IGUAL)
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(Array(loopedFilters.enumerated()), id: \.offset) { index, filter in
                                    CarouselChip(
                                        title: filter.rawValue,
                                        isSelected: selectedFilter == filter,
                                        onCenterChange: { midX in
                                            chipCenters[index] = midX
                                        }
                                    ) {
                                        select(filter, at: index, proxy: proxy)
                                    }
                                    .id(index)
                                }
                            }
                            .padding(.horizontal, 48)
                            .padding(.vertical, 14)
                        }
                        .gesture(
                            DragGesture().onEnded { _ in
                                snapToClosest(proxy: proxy)
                            }
                        )
                        .onAppear {
                            initialScroll(proxy: proxy)
                        }
                    }

                    // ✅ FEED DE NOTIFICACIONES (DISEÑO ORIGINAL + GLASS)
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredItems) { item in
                                ActivityRow(item: item)
                                    .frame(maxWidth: 360)
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 24)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Actividad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        .tint(.white)
        .onAppear {
            selectedFilter = ActivityFilter(rawValue: storedFilter) ?? .all
        }
    }

    // MARK: - Loop + Snap

    private func initialScroll(proxy: ScrollViewProxy) {
        guard !didInitialScroll else { return }
        didInitialScroll = true
        DispatchQueue.main.async {
            proxy.scrollTo(loopedFilters.count / 2, anchor: .center)
        }
    }

    private func snapToClosest(proxy: ScrollViewProxy) {
        let screenMidX = UIScreen.main.bounds.midX
        guard let closestIndex = chipCenters.min(by: {
            abs($0.value - screenMidX) < abs($1.value - screenMidX)
        })?.key else { return }
        select(loopedFilters[closestIndex], at: closestIndex, proxy: proxy)
    }

    private func select(_ filter: ActivityFilter, at index: Int, proxy: ScrollViewProxy) {
        selectedFilter = filter
        storedFilter = filter.rawValue

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
            proxy.scrollTo(index, anchor: .center)
        }
    }
}

//
// MARK: - Activity Row (NOTIFICACIÓN CON GLASS REAL)
//
private struct ActivityRow: View {
    let item: ActivityView.ActivityItem

    private var icon: String {
        switch item.type {
        case .likes: return "heart.fill"
        case .comments: return "message.fill"
        case .follows: return "person.badge.plus"
        case .events: return "calendar"
        case .all: return "bell.fill"
        }
    }

    private var color: Color {
        switch item.type {
        case .likes: return .red
        case .comments: return .blue
        case .follows: return .green
        case .events: return .purple
        case .all: return .gray
        }
    }

    private var text: String {
        switch item.type {
        case .likes: return "le dio me gusta a tu evento"
        case .comments: return "comentó en tu evento"
        case .follows: return "empezó a seguirte"
        case .events: return "creó un nuevo evento"
        case .all: return "actividad reciente"
        }
    }

    var body: some View {
        HStack(spacing: 12) {

            Circle()
                .fill(color.opacity(0.9))
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                        .font(.system(size: 18, weight: .semibold))
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.userName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)

                Text(text)
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.75))

                Text(item.time)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            if item.type == .events {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .padding(14)
        .background {
            if #available(iOS 26.0, *) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.clear)
                    .glassEffect(.clear.interactive())
            } else {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .background(.ultraThinMaterial)
            }
        }
    }
}

//
// MARK: - Carousel Chip (SE QUEDA IGUAL)
//
private struct CarouselChip: View {
    let title: String
    let isSelected: Bool
    let onCenterChange: (CGFloat) -> Void
    let action: () -> Void

    @State private var scale: CGFloat = 1.0

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
        }
        .background {
            if #available(iOS 26.0, *) {
                Capsule()
                    .fill(Color.clear)
                    .glassEffect(isSelected ? .clear.interactive() : .clear)
            } else {
                Capsule()
                    .fill(Color.clear)
                    .background(.ultraThinMaterial)
            }
        }
        .scaleEffect(scale)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: scale)
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear { update(from: geo) }
                    .onChange(of: geo.frame(in: .global).midX) { _ in
                        update(from: geo)
                    }
            }
        )
    }

    private func update(from geo: GeometryProxy) {
        let midX = geo.frame(in: .global).midX
        let screenMidX = UIScreen.main.bounds.midX
        let distance = abs(midX - screenMidX)

        scale = max(0.9, 1.15 - (distance / 500))
        onCenterChange(midX)
    }
}

#Preview {
    ActivityView()
}
