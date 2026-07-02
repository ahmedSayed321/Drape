//
//  FetchAllProductsUseCase.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

protocol FetchAllProductsUseCaseProtocol {
    func execute() async throws -> [Product]
}

final class FetchAllProductsUseCase: FetchAllProductsUseCaseProtocol {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol = SearchRepositoryImpl()) {
        self.repository = repository
    }

    func execute() async throws -> [Product] {
        try await repository.fetchAllProducts()
    }
}
