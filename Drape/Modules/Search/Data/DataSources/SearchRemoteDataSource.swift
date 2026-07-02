//
//  SearchRemoteDataSource.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

protocol SearchRemoteDataSourceProtocol {
    func fetchAllProducts(limit: Int, sortOrder: String) async throws -> ProductsResponseDTO
}

class SearchRemoteDataSource : SearchRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    func fetchAllProducts(limit: Int = 50, sortOrder: String = "created_at desc") async throws -> ProductsResponseDTO {
        let endPoint = SearchEndpoint.fetchAll(limit: limit, sortOrder: sortOrder)
        return try await networkService.request(endPoint)
    }
}
