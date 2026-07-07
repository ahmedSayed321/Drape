//
//  ProductDetailsViewModel.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation
import Observation

@Observable
class ProductDetailsViewModel {

    private let useCase: GetProductDetailsUseCase

    var state: ProductDetailsState = .idle

    
    var isAddingToCart: Bool = false
    var showAddToCartSuccessAlert: Bool = false
    var addToCartErrorMessage: String? = nil

    
    init(useCase: GetProductDetailsUseCase = GetProductDetailsUseCase()) {
        self.useCase = useCase
    }

    func fetchProductDetails(productId: Int) async {
        state = .loading

        do {
            let product = try await useCase.execute(productId: productId)
            state = .success(product)
        } catch {
            state = .failure(error.localizedDescription)
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
