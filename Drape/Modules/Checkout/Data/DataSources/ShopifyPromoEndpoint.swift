//
//  ShopifyPromoEndpoint.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

enum ShopifyPromoEndpoint: APIEndpoint {
    case lookupDiscountCode(code: String)
    case getPriceRule(priceRuleId: Int)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .lookupDiscountCode:
            return "/discount_codes/lookup.json"
        case .getPriceRule(let priceRuleId):
            return "/price_rules/\(priceRuleId).json"
        }
    }

    var method: HTTPMethod { .get }

    var queryParameters: [String: String]? {
        switch self {
        case .lookupDiscountCode(let code):
            return ["code": code]
        case .getPriceRule:
            return nil
        }
    }
}

struct ShopifyDiscountLookupDTO: Decodable {
    let price_rule_id: Int
    let id: Int          // discount_code_id
    let code: String
}

struct ShopifyPriceRuleResponseDTO: Decodable {
    let price_rule: ShopifyPriceRuleDTO
}

struct ShopifyPriceRuleDTO: Decodable {
    let id: Int
    let value_type: String   // "percentage" or "fixed_amount"
    let value: String        // Shopify returns this as a string, e.g. "-15.0"
    let target_type: String
    let starts_at: String
    let ends_at: String?
}
