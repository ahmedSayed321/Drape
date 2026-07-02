//
//  ShopifyNetworkService.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

protocol HomeRemoteDataSourceProtocol {
    func fetchAllProducts() async throws -> [ProductDTO]
    func fetchVendors() async throws -> [VendorDTO]
}


class HomeRemoteDataSource: HomeRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func fetchAllProducts() async throws -> [ProductDTO] {
        let response: ProductsResponse = try await networkService.request(ProductsEndpoint(limit: 50))
        return response.products
    }

    func fetchVendors() async throws -> [VendorDTO] {
        let response: VendorResponse = try await networkService.request(VendorsEndpoint())
        return response.smartCollections
    }
}
