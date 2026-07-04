//
//  ProductDetailEntity.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

struct ProductDetailsEntity {
    let title: String
    let description: String
    let vendor: String
    let productType: String
    
    let sizes: [String]
    
    let mainImage: String?
    let imageURLs: [String]
    let price: Double
}
