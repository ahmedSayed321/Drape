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
    case fetchMetafields(customerId: String)
    case updateMetafield(customerId: String, body: UpdateMetafieldRequestDTO)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .searchCustomer:   return "/customers/search.json"
        case .createCustomer:   return "/customers.json"
        case .fetchMetafields(let id), .updateMetafield(let id, _): return "/customers/\(id)/metafields.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchCustomer, .fetchMetafields:   return .get
        case .createCustomer, .updateMetafield:   return .post
        }
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
        case .updateMetafield(_, let body): return body
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

