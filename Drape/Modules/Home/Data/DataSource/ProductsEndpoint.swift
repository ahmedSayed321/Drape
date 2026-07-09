//
//  ProductsEndpoint.swift
//  Drape
//
//  Created by Moaz on 02/07/2026.
//

import Foundation

struct ProductsEndpoint: APIEndpoint {
    let limit: Int?
    let vendor: String?
    let ids: String?
    
    init(limit: Int? = nil, vendor: String? = nil, ids: String? = nil) {
        self.limit = limit
        self.vendor = vendor
        self.ids = ids
    }

    var baseURL: String { ShopifyConfig.baseURL }
    var path: String { "/products.json" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { ShopifyConfig.defaultHeaders }
    var queryParameters: [String: String]? {
        var params: [String: String] = [:]
        if let limit { params["limit"] = "\(limit)" }
        if let vendor { params["vendor"] = vendor }
        if let ids { params["ids"] = ids }
        return params.isEmpty ? nil : params
    }
}

struct VendorsEndpoint: APIEndpoint {
    var baseURL: String { ShopifyConfig.baseURL }
    var path: String { "/smart_collections.json" }
    var method: HTTPMethod { .get }
    var headers: [String: String] { ShopifyConfig.defaultHeaders }
    var queryParameters: [String: String]? { nil }
}
