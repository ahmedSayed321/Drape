//
//  CustomerAddressRemoteDataSource.swift
//  Drape
//
//  Created by TaqieAllah on 06/07/2026.
//

import Foundation

protocol ShopifyCustomerAddressRemoteDataSourceProtocol {
    func getAddresses(customerId: Int) async throws -> ShopifyCustomerAddressListResponseDTO
    func addAddress(customerId: Int, body: ShopifyCustomerAddressRequestDTO) async throws -> ShopifyCustomerAddressResponseDTO
    func deleteAddress(customerId: Int, addressId: Int) async throws
}



final class ShopifyCustomerAddressRemoteDataSource: ShopifyCustomerAddressRemoteDataSourceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func getAddresses(customerId: Int) async throws -> ShopifyCustomerAddressListResponseDTO {
        try await networkService.request(ShopifyCustomerAddressEndpoint.getAddresses(customerId: customerId))
    }

    func addAddress(customerId: Int, body: ShopifyCustomerAddressRequestDTO) async throws -> ShopifyCustomerAddressResponseDTO {
        do {
            return try await networkService.request(ShopifyCustomerAddressEndpoint.addAddress(customerId: customerId, body: body))
        } catch let error as NetworkError {
            if case .decodingFailed = error {
                print("❌ Address decoding failed. Check the response structure.")
            }
            throw error
        } catch {
            throw error
        }
    }

    func deleteAddress(customerId: Int, addressId: Int) async throws {
        let _: EmptyResponse = try await networkService.request(ShopifyCustomerAddressEndpoint.deleteAddress(customerId: customerId, addressId: addressId))
    }
}


struct EmptyResponse: Decodable {}
