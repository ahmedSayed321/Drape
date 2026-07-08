//
//  ShopifyCheckoutRemoteDataSource.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

final class ShopifyCheckoutRemoteDataSource {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func getDraftOrder(id: Int) async throws -> ShopifyDraftOrderResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.getDraftOrder(id: id))
    }

    func completeDraftOrder(id: Int, paymentPending: Bool) async throws -> ShopifyDraftOrderResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.completeDraftOrder(id: id, paymentPending: paymentPending))
    }

    func getOrder(id: Int) async throws -> ShopifyOrderResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.getOrder(id: id))
    }

    func getCustomerOrders(customerId: Int) async throws -> ShopifyCustomerOrdersResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.getCustomerOrders(customerId: customerId))
    }
    
    func createOrder(_ body: ShopifyOrderRequestDTO) async throws -> ShopifyOrderResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.createOrder(body: body))
    }
}
