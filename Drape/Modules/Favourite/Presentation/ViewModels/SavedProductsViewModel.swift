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

    private let getSavedProductsUseCase: GetSavedProductsUseCaseProtocol
    private let removeSavedProductUseCase: RemoveSavedProductUseCaseProtocol

    init(
        getSavedProductsUseCase: GetSavedProductsUseCaseProtocol,
        removeSavedProductUseCase: RemoveSavedProductUseCaseProtocol
    ) {
        self.getSavedProductsUseCase = getSavedProductsUseCase
        self.removeSavedProductUseCase = removeSavedProductUseCase
        loadProducts()
    }

    func loadProducts() {
        do {
            products = try getSavedProductsUseCase.execute()
        } catch {
            errorMessage = "Failed to load saved products"
        }
    }

    func remove(_ product: SavedProduct) {
        do {
            try removeSavedProductUseCase.execute(productID: product.id)
            loadProducts()
        } catch {
            errorMessage = "Failed to remove product"
        }
    }
}
