//
//  ProductDetailsEndPoint.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

struct ProductsDetailsEndpoint: APIEndpoint {
    var queryParameters: [String : String]? = nil
    
    let productId : Int
    var baseURL: String { ShopifyConfig.baseURL }
    var path: String {
        "/products/\(productId).json"
      }
    var method: HTTPMethod { .get }
    var headers: [String: String] { ShopifyConfig.defaultHeaders }
    
}
