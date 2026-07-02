//
//  HomeRepositoryProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

protocol HomeRepositoryProtocol {
    func fetchProducts() async throws -> [Product]
    func fetchBrands() async throws -> [Brand]
}
