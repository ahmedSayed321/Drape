//
//  RemoveCartLineItemUseCase.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

protocol RemoveCartLineItemUseCaseProtocol {
    func execute(draftOrderId: String, variantId: String) async throws -> Cart
}

struct RemoveCartLineItemUseCase: RemoveCartLineItemUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func execute(draftOrderId: String, variantId: String) async throws -> Cart {
        try await repository.removeLineItem(draftOrderId: draftOrderId, variantId: variantId)
    }
}
