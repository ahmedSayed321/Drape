//
//  ProductDetailsRepoImpl.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

class ProductDetailsRepoImpl : ProductDetailsRepoProtocol {
    
    private let remoteDataSource : ProductDetailsDataSourceProtocol
    
    init(remoteDataSource: ProductDetailsDataSourceProtocol = ProductDetailsDataSource()) {
        self.remoteDataSource = remoteDataSource
    }
    
    
    func fetchProductDetails(productId: Int) async throws -> ProductDetailsEntity {
        let product = try await remoteDataSource.fetchProductDetails(productId: productId)
        
        return product.toEntity()
    }
    
    
    func addToCart(
            variantId: String,
            customerId: String,
            quantity: Int
        ) async throws -> DraftOrderResponseDTO {

            return try await remoteDataSource.addToCart(
                variantId: variantId,
                customerId: customerId,
                quantity: quantity
            )
        }
    
}
