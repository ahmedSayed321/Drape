//
//  ClearAllSavedProductsUseCaseProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 09/07/2026.
//

protocol ClearAllSavedProductsUseCaseProtocol {
    func execute() throws
}
struct ClearAllSavedProductsUseCase: ClearAllSavedProductsUseCaseProtocol {
    let repository: SavedProductsRepository
    func execute() throws {
        try repository.removeAll()
    }
}
