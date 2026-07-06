//
//  SavedProductsRepositoryImpl.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData
import Foundation


// Data/Repositories/SavedProductsRepositoryImpl.swift
final class SavedProductsRepositoryImpl: SavedProductsRepository {
    private let localDataSource: SavedProductsLocalDataSource

    init(localDataSource: SavedProductsLocalDataSource) {
        self.localDataSource = localDataSource
    }

    func getAll() throws -> [SavedProduct] {
        try localDataSource.getAll().map { $0.toDomain() }
    }

    func save(_ product: SavedProduct) throws {
        let model = SavedProductModel(
            id: product.id,
            title: product.title,
            imageURLString: product.imageURL,
            price: product.price
        )
        try localDataSource.save(model)
    }

    func remove(_ productID: Int) throws {
        try localDataSource.remove(productID)
    }

    func isSaved(_ productID: Int) throws -> Bool {
        try localDataSource.isSaved(productID)
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
