//
//  LoadMoreProductsUseCaseProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//


protocol LoadMoreProductsUseCaseProtocol {
    func execute(limit: Int) async throws -> [Product]
}

class LoadMoreProductsUseCase: LoadMoreProductsUseCaseProtocol {
    private let homeRepository: HomeRepositoryProtocol
    init(homeRepository: HomeRepositoryProtocol = HomeRepositoryImpl()) {
        self.homeRepository = homeRepository
    }

    func execute(limit: Int) async throws -> [Product] {
        try await homeRepository.fetchProducts(limit: limit)
    }
}
