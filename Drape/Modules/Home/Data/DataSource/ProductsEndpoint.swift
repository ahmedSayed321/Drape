//
//  ProductsEndpoint.swift
//  Drape
//
//  Created by Moaz on 02/07/2026.
//

import Foundation

struct ProductsEndpoint: APIEndpoint {
    let limit: Int?

    var baseURL: String { ShopifyConfig.baseURL }
    var path: String { "/products.json" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { ShopifyConfig.defaultHeaders }
    var queryParameters: [String: String]? {
        guard let limit else { return nil }
        return ["limit": "\(limit)"]
    }
}

struct VendorsEndpoint: APIEndpoint {
    var baseURL: String { ShopifyConfig.baseURL }
    var path: String { "/smart_collections.json" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { ShopifyConfig.defaultHeaders }
    var queryParameters: [String: String]? { nil }
}
