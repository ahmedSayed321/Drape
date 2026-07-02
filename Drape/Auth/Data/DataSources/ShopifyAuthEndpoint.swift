//
//  ShopifyAuthEndpoint.swift
//  Drape
//
//  Created by TaqieAllah on 02/07/2026.
//

import Foundation

enum ShopifyAuthEndpoint: APIEndpoint {
    case searchCustomer(email: String)
    case createCustomer(body: ShopifyCreateCustomerRequestDTO)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .searchCustomer:   return "/customers/search.json"
        case .createCustomer:   return "/customers.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchCustomer:   return .get
        case .createCustomer:   return .post
        }
    }

    var headers: [String: String] {
        [
            "X-Shopify-Access-Token": ShopifyConfig.accessToken,
            "Content-Type": "application/json"
        ]
    }

    var queryParameters: [String: String]? {
        switch self {
        case .searchCustomer(let email):
            return ["query": "email:\(email)"]
        default:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case .createCustomer(let body): return body
        default: return nil
        }
    }
}


struct AnyEncodable: Encodable {
    private let _encode: (Encoder) throws -> Void
    
    init(_ wrapped: some Encodable) {
        _encode = wrapped.encode
    }
    
    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}

