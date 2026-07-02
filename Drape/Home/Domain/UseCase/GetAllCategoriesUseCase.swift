//
//  GetAllCategoriesUseCase.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 02/07/2026.
//

import Foundation

class GetAllCategoriesUseCase {
    
    let homeRepository: HomeRepositoryProtocol
    
    init(homeRepository: HomeRepositoryProtocol = HomeRepositoryImpl()) {
        self.homeRepository = homeRepository
    }
    
    func execute() async throws -> [String] {
        
        let products = try await homeRepository.fetchProducts()
        
        
        let categories: [String] = products.map { $0.productType }
        let uniqueCategories = NSOrderedSet(array: categories).array as? [String] ?? []
        
        return uniqueCategories
    }
}
