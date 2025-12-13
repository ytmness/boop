//
//  ExploreView.swift
//  BoopApp
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                GlassAnimatedBackground()
                
                Text("Explorar")
                    .font(.title)
                    .foregroundStyle(.white)
            }
            .navigationTitle("Explorar")
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
    }
}

#Preview {
    ExploreView()
}

