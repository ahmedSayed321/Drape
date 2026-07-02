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
    let brand: String // ex: Adidas
    let productType: String // ex: Shoes
    let price: String
    let imageUrl: String?
}
