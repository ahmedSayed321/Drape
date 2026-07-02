//
//  ProductDTO.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

struct ProductsResponseDTO: Decodable {
    let products: [ProductDTO]
}

struct ProductDTO: Decodable {
    let id: Int
    let title: String
    let vendor: String
    let productType: String
    let status: String
    let variants: [VariantDTO]
    let images: [ProductImageDTO]

    enum CodingKeys: String, CodingKey {
        case id, title, vendor, status
        case productType = "product_type"
        case variants, images
    }
}


