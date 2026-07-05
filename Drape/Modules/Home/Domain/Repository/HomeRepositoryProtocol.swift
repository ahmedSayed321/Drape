//
//  HomeRepositoryProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

protocol HomeRepositoryProtocol {
    func fetchProducts(vendor: String?, limit: Int) async throws -> [Product]
    func fetchBrands() async throws -> [Brand]
}

extension HomeRepositoryProtocol {
    func fetchProducts(limit: Int) async throws -> [Product] {
        try await fetchProducts(vendor: nil, limit: limit)
    }
}
