//
//  HomeRepository.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

class HomeRepositoryImpl: HomeRepositoryProtocol {
    
    private let remoteDataSource: HomeRemoteDataSourceProtocol
    
    init(remoteDataSource: HomeRemoteDataSourceProtocol = HomeRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchProducts() async throws -> [Product] {
        let productDTOs = try await remoteDataSource.fetchAllProducts()
        return productDTOs.map { $0.convertToEntity() }
    }
    
    func fetchBrands() async throws -> [Brand] {
        let vendorDTOs = try await remoteDataSource.fetchVendors()
        return vendorDTOs.map { $0.convertToBrand() }
    }
}
