//
//  Product.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let title: String
    let vendor: String
    let productType: String
    let price: String
    let compareAtPrice: String?
    let imageURL: String

    var discountPercentage: String? {
        guard
            let compareAt = compareAtPrice,
            let compareAtDouble = Double(compareAt),
            let priceDouble = Double(price),
            compareAtDouble > priceDouble
        else { return nil }

        let discount = ((compareAtDouble - priceDouble) / compareAtDouble) * 100
        return "-\(Int(discount))%"
    }
}
