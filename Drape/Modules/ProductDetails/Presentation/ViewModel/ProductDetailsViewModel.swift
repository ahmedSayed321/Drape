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

    init(useCase: GetProductDetailsUseCase = GetProductDetailsUseCase()) {
        self.useCase = useCase
    }

    func fetchProductDetails(productId: Int) async {
        state = .loading

        do {
            let product = try await useCase.execute(productId: productId)
            state = .success(product)
            print("here is the desc :\(product.description)")
        } catch {
            state = .failure(error.localizedDescription)
        }
    }
}
