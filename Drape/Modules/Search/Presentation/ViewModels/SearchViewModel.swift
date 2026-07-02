//
//  SearchViewModel.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

enum SearchState {
    case loading
    case recentResults
    case success([Product])
    case noResult
}

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var state: SearchState = .recentResults
    @Published var searchText: String = ""
    @Published var errorMessage: String? = nil
    @Published var recentSearches: [String] = []

    private var products: [Product] = []
    private var hasFetchedProducts: Bool = false

    private let useCase: FetchAllProductsUseCaseProtocol
    private let recentSearchesRepository: RecentSearchesRepositoryProtocol

    init(
        useCase: FetchAllProductsUseCaseProtocol = FetchAllProductsUseCase(),
        recentSearchesRepository: RecentSearchesRepositoryProtocol = RecentSearchesRepositoryImpl()
    ) {
        self.useCase = useCase
        self.recentSearchesRepository = recentSearchesRepository
        self.recentSearches = recentSearchesRepository.getRecentSearches()
    }

    func loadProducts() async {
        state = .loading
        errorMessage = nil
        do {
            products = try await useCase.execute()
            hasFetchedProducts = true
            state = products.isEmpty ? .noResult : .success(products)
        } catch {
            errorMessage = error.localizedDescription
            state = .noResult
        }
    }

    func filterProducts() {
        let filtered = products.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        state = filtered.isEmpty ? .noResult : .success(filtered)
    }

    func onSearchTextChanged(_ text: String) {
        if text.isEmpty {
            state = .recentResults
        } else {
            Task {
                if !hasFetchedProducts {
                    await loadProducts()
                }
                filterProducts()
            }
        }
    }

    // Recent Searches
    func saveInRecentSearches() {
        recentSearchesRepository.save(searchText)
        recentSearches = recentSearchesRepository.getRecentSearches()
    }

    func removeRecentSearch(_ query: String) {
        recentSearchesRepository.remove(query)
        recentSearches = recentSearchesRepository.getRecentSearches()
    }

    func clearAllRecentSearches() {
        recentSearchesRepository.clearAll()
        recentSearches = recentSearchesRepository.getRecentSearches()
    }
}
