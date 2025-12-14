//
//  EventsViewModel.swift
//  BoopApp
//
//  ViewModel para manejar el estado de eventos
//

import Foundation
import Observation

@Observable
final class EventsViewModel {
    private let repo = EventsRepository()

    var events: [EventRow] = []
    var isLoading = false
    var errorMessage: String?

    @MainActor
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            events = try await repo.fetchEvents()
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error al cargar eventos: \(error.localizedDescription)")
        }
        isLoading = false
    }

    @MainActor
    func addToTop(_ event: EventRow) {
        events.insert(event, at: 0)
    }
    
    @MainActor
    func refresh() async {
        await load()
    }
}
