//
//  UpdateCartItemQuantityUseCase.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

protocol UpdateCartItemQuantityUseCaseProtocol {
    func execute(draftOrderId: String, variantId: String, quantity: Int) async throws -> Cart
}

struct UpdateCartItemQuantityUseCase: UpdateCartItemQuantityUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func execute(draftOrderId: String, variantId: String, quantity: Int) async throws -> Cart {
        try await repository.updateLineItemQuantity(draftOrderId: draftOrderId, variantId: variantId, quantity: quantity)
    }
}
