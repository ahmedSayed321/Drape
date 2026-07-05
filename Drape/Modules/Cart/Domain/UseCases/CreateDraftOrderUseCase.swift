//
//  CreateDraftOrderUseCase.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

protocol CreateDraftOrderUseCaseProtocol {
    func execute(items: [CartLineItem]) async throws -> Cart
}

struct CreateDraftOrderUseCase: CreateDraftOrderUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func execute(items: [CartLineItem]) async throws -> Cart {
        try await repository.createDraftOrder(items: items)
    }
}
