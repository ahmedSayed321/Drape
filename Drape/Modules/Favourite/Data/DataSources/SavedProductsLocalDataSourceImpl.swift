//
//  SavedProductsLocalDataSourceImpl.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 05/07/2026.
//


// Data/DataSources/SavedProductsLocalDataSourceImpl.swift
import SwiftData
import Foundation

final class SavedProductsLocalDataSourceImpl: SavedProductsLocalDataSource {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func getAll() throws -> [SavedProductModel] {
        let descriptor = FetchDescriptor<SavedProductModel>(
            sortBy: [SortDescriptor(\.title)]
        )
        return try context.fetch(descriptor)
    }

    func save(_ model: SavedProductModel) throws {
        context.insert(model)
        try context.save()
    }

    func remove(_ productID: Int) throws {
        let descriptor = FetchDescriptor<SavedProductModel>(
            predicate: #Predicate { $0.id == productID }
        )
        if let model = try context.fetch(descriptor).first {
            context.delete(model)
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
