//
//  ClearCartUseCase.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

protocol ClearCartUseCaseProtocol {
    func execute(draftOrderId: String) async throws
}

struct ClearCartUseCase: ClearCartUseCaseProtocol {
    private let repository: CartRepository

    init(repository: CartRepository) {
        self.repository = repository
    }

    func execute(draftOrderId: String) async throws {
        try await repository.clearCart(draftOrderId: draftOrderId)
    }
}
