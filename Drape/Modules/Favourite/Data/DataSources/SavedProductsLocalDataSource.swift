//
//  SavedProductsLocalDataSource.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 05/07/2026.
//


// Data/DataSources/SavedProductsLocalDataSource.swift
protocol SavedProductsLocalDataSource {
    func getAll() throws -> [SavedProductModel]
    func save(_ model: SavedProductModel) throws
    func remove(_ productID: Int) throws
    func removeAll() throws
    func isSaved(_ productID: Int) throws -> Bool
}