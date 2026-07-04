//
//  SavedProduct.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import Foundation

struct SavedProduct: Identifiable, Equatable {
    let id: Int
    let title: String
    let imageURL: String?
    let price: String
}

extension SavedProduct {
    func toUIState() -> ProductCardUIState {
        ProductCardUIState(
            id: self.id,
            name: self.title,
            price: self.price,
            imageUrl: self.imageURL
        )
    }
}
