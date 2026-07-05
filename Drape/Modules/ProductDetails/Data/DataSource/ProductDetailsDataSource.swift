//
//  ProductDetailsDataSource.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

protocol ProductDetailsDataSourceProtocol{
    func fetchProductDetails(productId : Int) async throws -> ProductDetail
}

class ProductDetailsDataSource : ProductDetailsDataSourceProtocol{
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }
    
    
    
    func fetchProductDetails(productId: Int) async throws -> ProductDetail {
        
        let response : ProductDetailsResponse = try await networkService.request(ProductsDetailsEndpoint(productId: productId))
        
        guard let response = response.product else{
            throw ProductError.productNotFound
        }
        
        print("Data source desc \(response)")
        return response
    }
    
    
}

enum ProductError: Error {
    case productNotFound
}
