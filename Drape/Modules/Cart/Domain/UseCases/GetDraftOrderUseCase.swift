//
//  GetDraftOrderUseCase.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

protocol GetDraftOrderUseCaseProtocol {
    func execute(id: String) async throws -> Cart
}

struct GetDraftOrderUseCase: GetDraftOrderUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func execute(id: String) async throws -> Cart {
        try await repository.getDraftOrder(id: id)
    }
}
