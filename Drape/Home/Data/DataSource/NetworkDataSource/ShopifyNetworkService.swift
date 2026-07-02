//
//  ShopifyNetworkService.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchProdcuts() async throws -> [ProductDTO]
    func fetchVendors() async throws -> [VendorDTO]
}

class ShopifyNetworkService: NetworkServiceProtocol {
    
    static let shared = ShopifyNetworkService()
    
    private init() {}
    
    func fetchProdcuts() async throws -> [ProductDTO] {
        
        let response: ProductResponse = try await ShopifyNetworkManager.fetch(endpoint: "products.json")
        
        print(response.products[0].title)
        
        return response.products
    }
    
    func fetchVendors() async throws -> [VendorDTO] {
        
        let response: VendorResponse = try await ShopifyNetworkManager.fetch(endpoint: "smart_collections.json")
        
        print(response.smartCollections[0].title)
        
        return response.smartCollections
    }
    
}
