//
//  ProductDetailsRepo.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

protocol ProductDetailsRepoProtocol{
    func fetchProductDetails(productId : Int) async throws -> ProductDetailsEntity
}
