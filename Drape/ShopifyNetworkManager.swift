//
//  ShopifyNetworkService.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation
import Alamofire

class ShopifyNetworkManager {
    
    static func fetch<T: Decodable>(endpoint: String) async throws -> T {
        
        let url = "https://\(APIConfig.shopifyShopName).myshopify.com/admin/api/2026-01/\(endpoint)"

        let headers: HTTPHeaders = [
            "X-Shopify-Access-Token": APIConfig.shopifyApiKey,
            "Content-Type": "application/json"
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: .get, headers: headers)
                .validate()
                .responseDecodable(of: T.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
