//
//  ShopifyRemoteDataSource.swift
//  Drape
//
//  Created by TaqieAllah on 02/07/2026.
//

import Foundation

final class ShopifyAuthRemoteDataSource {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func searchCustomer(byEmail email: String) async throws -> ShopifySearchResponseDTO {
        try await networkService.request(ShopifyAuthEndpoint.searchCustomer(email: email))
    }

    func createCustomer(_ body: ShopifyCreateCustomerRequestDTO) async throws -> ShopifyCreateResponseDTO {
        try await networkService.request(ShopifyAuthEndpoint.createCustomer(body: body))
    }
}



struct ShopifySearchResponseDTO: Decodable {
    let customers: [ShopifyCustomerDTO]
}

struct ShopifyCustomerDTO: Decodable {
    let id: Int
    let email: String?
    let first_name: String?
    let last_name: String?
}

struct ShopifyCreateCustomerRequestDTO: Encodable {
    struct CustomerBody: Encodable {
        let first_name: String
        let last_name: String
        let email: String
        let tags: String
    }
    let customer: CustomerBody
}

struct ShopifyCreateResponseDTO: Decodable {
    let customer: ShopifyCustomerDTO
}
