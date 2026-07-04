//
//  PromoCodeRepository.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation


final class PromoCodeRepository: PromoCodeRepositoryProtocol {

    private let remoteDataSource: ShopifyPromoRemoteDataSource

    init(remoteDataSource: ShopifyPromoRemoteDataSource = ShopifyPromoRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func validate(code: String) async throws -> ValidatedPromoCode {
        let lookup: ShopifyDiscountLookupDTO
        do {
            lookup = try await remoteDataSource.lookupDiscountCode(code).discountCode
        } catch NetworkError.serverError(let statusCode) where statusCode == 404 {
            throw PromoCodeError.invalidCode
        } catch {
            throw PromoCodeError.networkFailure
        }

        let ruleResponse: ShopifyPriceRuleResponseDTO
        do {
            ruleResponse = try await remoteDataSource.getPriceRule(id: lookup.priceRuleId)
        } catch {
            throw PromoCodeError.networkFailure
        }

        let rule = ruleResponse.priceRule
        try checkDateValidity(rule)

        guard let magnitude = Double(rule.value) else {
            throw PromoCodeError.invalidCode
        }

        return ValidatedPromoCode(
            code: lookup.code,
            priceRuleId: lookup.priceRuleId,
            discountCodeId: lookup.id,
            valueType: rule.value_type,
            value: abs(magnitude)
        )
    }

    private func checkDateValidity(_ rule: ShopifyPriceRuleDTO) throws {
        let formatter = ISO8601DateFormatter()

        if let startsAt = formatter.date(from: rule.starts_at), Date() < startsAt {
            throw PromoCodeError.notYetActive
        }

        if let endsAtString = rule.ends_at,
           let endsAt = formatter.date(from: endsAtString),
           Date() > endsAt {
            throw PromoCodeError.expired
        }
    }
}
