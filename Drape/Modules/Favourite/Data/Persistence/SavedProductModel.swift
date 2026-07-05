//
//  SavedProductEntity.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//


import SwiftData

@Model
final class SavedProductModel {
    @Attribute(.unique) var id: Int
    var title: String?
    var imageURLString: String?
    var price: String?

    init(id: Int, title: String, imageURLString: String?, price: String) {
        self.id = id
        self.title = title
        self.imageURLString = imageURLString
        self.price = price
    }
}
