//
//  ProductEndpoint.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

enum SearchEndpoint: APIEndpoint {
    case fetchAll(limit: Int, sortOrder: String)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .fetchAll: return "/products.json"
        }
    }

    var method: HTTPMethod { .get }

    var headers: [String: String] { ShopifyConfig.defaultHeaders }

    var queryParameters: [String: String]? {
        switch self {
        case .fetchAll(let limit, let sortOrder):
            return [
                "limit": "\(limit)",
                "order": sortOrder
            ]
        }
    }
}
