//
//  ProductDetailsViewModel.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation
import Observation

@Observable
public class ProductDetailsViewModel {

    private let useCase: GetProductDetailsUseCase
    private let toggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol
    private let getSavedProductsUseCase: GetSavedProductsUseCaseProtocol

    var state: ProductDetailsState = .idle
    var isFavorite: Bool = false
    var errorMessage: String?
    
    private var currentProductId: Int?
    
    var isAddingToCart: Bool = false
    var showAddToCartSuccessAlert: Bool = false
    var addToCartErrorMessage: String? = nil

    
    init(useCase: GetProductDetailsUseCase = GetProductDetailsUseCase(),
         toggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol,
         getSavedProductsUseCase: GetSavedProductsUseCaseProtocol
    ) {
        self.useCase = useCase
        self.toggleSaveProductUseCase = toggleSaveProductUseCase
        self.getSavedProductsUseCase = getSavedProductsUseCase
    }

    func fetchProductDetails(productId: Int) async {
        self.currentProductId = productId
        state = .loading

        do {
            async let product = try await useCase.execute(productId: productId)
            async let savedProducts = try getSavedProductsUseCase.execute()
            
            let (productDetails, savedProductsResult) = try await (product, savedProducts)
            
            // Check if product is favorited
            isFavorite = savedProductsResult.contains { $0.id == productId }
            
            state = .success(productDetails)
            
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
    
    
    func toggleFavorite(product: ProductDetailsEntity) {
        guard let productId = currentProductId else { return }
        
        do {
            let savedProduct = SavedProduct(
                id: productId,
                title: product.title,
                imageURL: product.mainImage,
                price: String(format: "%.2f", product.price)
            )
            try toggleSaveProductUseCase.execute(product: savedProduct)
            isFavorite.toggle()
        } catch {
            errorMessage = "Failed to update favorite: \(error.localizedDescription)"
        }
    }
    
    func addToCart(
            variantId: String,
            customerId: String,
            quantity: Int
        ) async {

            isAddingToCart = true
            defer { isAddingToCart = false }

            do {
                _ = try await useCase.invokeAddToChart(
                    variantId: variantId,
                    customerId: customerId,
                    quantity: quantity
                )
                showAddToCartSuccessAlert = true
            } catch {
                addToCartErrorMessage = error.localizedDescription
            }
        }
}
