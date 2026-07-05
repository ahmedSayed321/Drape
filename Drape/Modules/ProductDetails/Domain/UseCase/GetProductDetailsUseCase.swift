//
//  GetProductDetailsUseCase.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation


class GetProductDetailsUseCase {
    
    private var remoteRepo : ProductDetailsRepoProtocol
    
    init(remoteRepo: ProductDetailsRepoProtocol = ProductDetailsRepoImpl()) {
        self.remoteRepo = remoteRepo
    }
    
    
    func execute(productId : Int) async throws -> ProductDetailsEntity{
        
        let product = try await remoteRepo.fetchProductDetails(productId: productId)
        
        return product
    }
}
