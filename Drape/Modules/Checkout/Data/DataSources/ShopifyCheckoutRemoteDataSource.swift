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

    func createDraftOrder(_ body: ShopifyDraftOrderRequestDTO) async throws -> ShopifyDraftOrderResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.createDraftOrder(body: body))
    }

    func updateDraftOrder(id: Int, body: ShopifyDraftOrderRequestDTO) async throws -> ShopifyDraftOrderResponseDTO {
        try await networkService.request(ShopifyCheckoutEndpoint.updateDraftOrder(id: id, body: body))
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
}
