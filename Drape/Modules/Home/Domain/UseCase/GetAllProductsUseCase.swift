//
//  GetAllProductsUseCase.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

// The UseCase represents a single business logic action
// ex: GetAllProductsUseCase, GetProductsFilteredByCategoryUseCase
class GetAllProductsUseCase {
    
    let homeRepository: HomeRepositoryProtocol
    
    init(homeRepository: HomeRepositoryProtocol = HomeRepositoryImpl()) {
        self.homeRepository = homeRepository
    }
    
    func execute() async throws -> [Product] {
        return try await homeRepository.fetchProducts()
    }
}
