//
//  SavedProductsViewModel.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import Combine


@MainActor
final class SavedProductsViewModel: ObservableObject {
    @Published private(set) var products: [SavedProduct] = []
    @Published private(set) var errorMessage: String?

    private let repository: SavedProductsRepository

    init(repository: SavedProductsRepository) {
        self.repository = repository
        loadProducts()
    }

    func loadProducts() {
        do {
            products = try repository.getAll()
        } catch {
            errorMessage = "Failed to load saved products"
        }
    }

    func remove(_ product: SavedProduct) {
        do {
            try repository.remove(product.id)
            loadProducts()
        } catch {
            errorMessage = "Failed to remove product"
        }
    }
}
