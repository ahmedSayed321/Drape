//
//  GetHomeScreenDataUseCase.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import Foundation

// MARK: - 1. Response Model
struct HomeScreenData {
    let products: [Product]
    let brands: [Brand]
    let categories: [String]
}

// MARK: - 2. Use Case Protocol
protocol GetHomeScreenDataUseCaseProtocol {
    func execute() async throws -> HomeScreenData
}

// MARK: - 3. Use Case Implementation
class GetHomeScreenDataUseCase: GetHomeScreenDataUseCaseProtocol {
    
    private let homeRepository: HomeRepositoryProtocol
    private let pageSize: Int
    
    init(homeRepository: HomeRepositoryProtocol = HomeRepositoryImpl(), pageSize: Int = 20) {
        self.homeRepository = homeRepository
        self.pageSize = pageSize
    }
    
    func execute() async throws -> HomeScreenData {
        // Run fetchProducts and fetchBrands concurrently
        async let productsTask = homeRepository.fetchProducts(limit: pageSize)
        async let brandsTask = homeRepository.fetchBrands()
        
        // Await the parallel results
        let products = try await productsTask
        let brands = try await brandsTask
        
        // Extract categories without extra network requests
        let categories = extractUniqueCategories(from: products)
        
        return HomeScreenData(
            products: products,
            brands: brands,
            categories: categories
        )
    }
    
    private func extractUniqueCategories(from products: [Product]) -> [String] {
        let rawCategories = products
            .map { $0.productType.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        // Maintains initial insertion order while wiping out duplicates efficiently
        var seen = Set<String>()
        return rawCategories.filter { seen.insert($0).inserted }
    }
}
