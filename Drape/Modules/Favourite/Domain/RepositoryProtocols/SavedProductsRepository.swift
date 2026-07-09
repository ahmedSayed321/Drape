//
//  SavedProductsRepository.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//


protocol SavedProductsRepository {
    func getAll() throws -> [SavedProduct]
    func save(_ product: SavedProduct) throws
    func remove(_ productID: Int) throws
    func removeAll() throws
    func isSaved(_ productID: Int) throws -> Bool
}
