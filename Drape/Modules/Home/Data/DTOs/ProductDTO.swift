//
//  ProductDTO.swift
//  Drape
//
//  Created by Moaz on 02/07/2026.
//

import Foundation

struct ProductsResponse: Codable {
    let products: [ProductDTO]
}

struct VendorsResponse: Codable {
    let smartCollections: [VendorDTO]
}

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let vendor: String
    let productType: String
    let variants: [VariantDTO]
    let image: ImageDTO?
    let options: [OptionDTO]
}

//struct VariantDTO: Codable {
//    let price: String
//}

extension ProductDTO {
    func convertToEntity() -> Product {
            return Product(
                id: self.id,
                name: self.title,
                brand: self.vendor,
                productType: self.productType,
                price: self.variants[0].price,
                imageUrl: self.image?.src,
                sizes: self.options.first(where: { $0.name.lowercased() == "size" })?.values ?? []
            )
        }
}
