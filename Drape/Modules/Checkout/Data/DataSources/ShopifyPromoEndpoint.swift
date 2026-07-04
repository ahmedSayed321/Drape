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

struct ShopifyDiscountLookupResponseDTO: Decodable {
    let discountCode: ShopifyDiscountLookupDTO
}

struct ShopifyDiscountLookupDTO: Decodable {
    let id: Int
    let priceRuleId: Int
    let code: String
}

struct ShopifyPriceRuleResponseDTO: Decodable {
    let priceRule: ShopifyPriceRuleDTO
}

struct ShopifyPriceRuleDTO: Decodable {
    let id: Int
    let valueType: String
    let value: String
    let targetType: String
    let startsAt: String
    let endsAt: String?
}
