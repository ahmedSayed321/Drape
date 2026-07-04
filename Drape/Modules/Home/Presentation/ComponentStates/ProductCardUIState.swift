//
//  ProductCardUIState.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 03/07/2026.
//


import SwiftUI

struct ProductCardUIState: Identifiable {
    let id: Int
    let name: String
    let price: String
    let imageUrl: String?
//    let isLiked: Bool
}

extension Product {

    func toUIState() -> ProductCardUIState {
        ProductCardUIState(
            id: self.id,
            name: self.name,
            price: self.price,
            imageUrl: self.imageUrl
//            ,isLiked: true // Set default initial state based on layout requirement
        )
    }
}
