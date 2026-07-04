//
//  SavedProductsRepositoryImpl.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData
import Foundation


final class SavedProductsRepositoryImpl: SavedProductsRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getAll() throws -> [SavedProduct] {
        let descriptor = FetchDescriptor<SavedProductModel>(
            sortBy: [SortDescriptor(\.title)]
        )
        return try context.fetch(descriptor).map { $0.toDomain() }
    }

    func save(_ product: SavedProduct) throws {
        let entity = SavedProductModel(
            id: product.id,
            title: product.title,
            imageURLString: product.imageURL,
            price: product.price
        )
        context.insert(entity)
        try context.save()
    }

    func remove(_ productID: Int) throws {
        let descriptor = FetchDescriptor<SavedProductModel>(
            predicate: #Predicate { $0.id == productID }
        )
        if let entity = try context.fetch(descriptor).first {
            context.delete(entity)
            try context.save()
        }
    }

    func isSaved(_ productID: Int) throws -> Bool {
        let descriptor = FetchDescriptor<SavedProductModel>(
            predicate: #Predicate { $0.id == productID }
        )
        return try context.fetch(descriptor).first != nil
    }
}

private extension SavedProductModel {
    func toDomain() -> SavedProduct {
        SavedProduct(
            id: id,
            title: title ?? "No Title Found",
            imageURL: imageURLString ?? "No Image",
            price: price ?? "No Price"
        )
    }
}
