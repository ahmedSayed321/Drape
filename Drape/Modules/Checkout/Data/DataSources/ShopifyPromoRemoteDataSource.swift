//
//  ShopifyPromoRemoteDataSource.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

final class ShopifyPromoRemoteDataSource {

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func lookupDiscountCode(_ code: String) async throws -> ShopifyDiscountLookupResponseDTO {
        try await networkService.request(ShopifyPromoEndpoint.lookupDiscountCode(code: code))
    }

    func getPriceRule(id: Int) async throws -> ShopifyPriceRuleResponseDTO {
        try await networkService.request(ShopifyPromoEndpoint.getPriceRule(priceRuleId: id))
    }
}
