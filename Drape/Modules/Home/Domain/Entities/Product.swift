//
//  Product.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

struct Product: Identifiable {
    let id: Int
    let name: String
    let brand: String
    let productType: String
    let price: String
    let imageUrl: String?
    let sizes: [String]   
}

extension Product {
    var priceValue: Double {
        let filtered = price.filter { $0.isNumber || $0 == "." }
        return Double(filtered) ?? 0
    }
}
