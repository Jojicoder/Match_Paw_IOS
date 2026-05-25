//
//  AnimalViewModel.swift
//  Match_Paw
//

import SwiftUI
import Combine

@MainActor
final class AnimalViewModel: ObservableObject {
    @Published var animals: [Animal] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var availableAnimals: [Animal] {
        animals.filter { $0.isAvailable }
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            animals = try await APIService.shared.fetchAnimals()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func filtered(query: String, species: String?) -> [Animal] {
        availableAnimals.filter { a in
            let q = query.lowercased()
            let matchQuery = q.isEmpty
                || a.name.lowercased().contains(q)
                || (a.breed?.lowercased().contains(q) ?? false)
                || a.species.lowercased().contains(q)
            let matchSpecies = species == nil || a.species == species
            return matchQuery && matchSpecies
        }
    }

    func animal(id: Int) -> Animal? {
        animals.first { $0.id == id }
    }
}
