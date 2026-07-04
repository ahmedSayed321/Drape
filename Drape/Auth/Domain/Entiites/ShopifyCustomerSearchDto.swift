//
//  ShopifyCustomerSearchDto.swift
//  Drape
//
//  Created by Me3bed on 01/07/2026.
//

import Foundation
 
struct ShopifyCustomerSearchResponseDTO: Decodable {
    let customers: [ShopifyCustomerIDDTO]
}
 
struct ShopifyCustomerIDDTO: Decodable {
    let id: Int
}
