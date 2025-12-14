//
//  ExploreView.swift
//  BoopApp
//
//  Explore feed público con selector de ciudad
//

import SwiftUI

struct ExploreView: View {
    @State private var selectedCity: String = "Ciudad de México"
    @State private var showCityPicker = false
    
    let cities = [
        "Ciudad de México",
        "Guadalajara",
        "Monterrey",
        "Puebla",
        "Tijuana",
        "León",
        "Querétaro",
        "Mérida"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                VStack(spacing: 0) {
                    // City selector
                    CitySelector(
                        selectedCity: $selectedCity,
                        cities: cities,
                        showPicker: $showCityPicker
                    )
                    .frame(maxWidth: 360)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                    
                    // Events feed
                    ScrollView {
                        LazyVStack(spacing: 24) {
                            ForEach(0..<10, id: \.self) { index in
                                EventFeedCard(
                                    eventNumber: index + 1,
                                    tabType: EventsHubView.EventsTab.explore
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .padding(.top, 8)
                    }
                    .ignoresSafeArea(.container, edges: .bottom)
                }
            }
            .navigationTitle("Explorar")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .sheet(isPresented: $showCityPicker) {
                CityPickerSheet(
                    selectedCity: $selectedCity,
                    cities: cities
                )
            }
        }
    }
}

// MARK: - City Selector
private struct CitySelector: View {
    @Binding var selectedCity: String
    let cities: [String]
    @Binding var showPicker: Bool
    
    var body: some View {
        Button(action: {
            showPicker = true
        }) {
            HStack(spacing: 8) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.system(size: 16))
                
                Text(selectedCity)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.system(size: 12))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.thinMaterial)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

// MARK: - City Picker Sheet
private struct CityPickerSheet: View {
    @Binding var selectedCity: String
    let cities: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                List {
                    ForEach(cities, id: \.self) { city in
                        Button(action: {
                            selectedCity = city
                            dismiss()
                        }) {
                            HStack {
                                Text(city)
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                if city == selectedCity {
                                    Image(systemName: "checkmark")
                                        .foregroundStyle(.white)
                                }
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Seleccionar Ciudad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
