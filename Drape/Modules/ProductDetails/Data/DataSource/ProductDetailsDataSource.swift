//
//  ProductDetailsDataSource.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

protocol ProductDetailsDataSourceProtocol{
    func fetchProductDetails(productId : Int) async throws -> ProductDetail
    
    func addToCart(
           variantId: String,
           customerId: String,
           quantity: Int
       ) async throws -> DraftOrderResponseDTO
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
        
        return response
    }
    
    func addToCart(
        variantId: String,
        customerId: String,
        quantity: Int
    ) async throws -> DraftOrderResponseDTO {
      

        let request = DraftOrderRequest(
            draftOrder: DraftOrder(
                lineItems: [
                    LineItem(
                        variantId: variantId,
                        quantity: quantity
                    )
                ],
                customer: Customer(id: customerId)
            )
        )

        let response: DraftOrderResponseDTO

        do {
            response = try await networkService.request(
                AddToChartEndPoint.create(request)
            )
        } catch {
            throw error
        }

        return response
    }
   
    
    
    
    
    
}

enum ProductError: Error {
    case productNotFound
}
