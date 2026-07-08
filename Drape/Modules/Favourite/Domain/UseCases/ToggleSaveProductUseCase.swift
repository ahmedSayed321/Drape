//
//  ToggleSaveProductUseCase.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//
protocol ToggleSaveProductUseCaseProtocol {
    func execute(product: SavedProduct) throws
}

struct ToggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol {
    let repository: SavedProductsRepository
    
    init(repository: SavedProductsRepository) {
        self.repository = repository
    }

    func execute(product: SavedProduct) throws {
        if try repository.isSaved(product.id) {
            try repository.remove(product.id)
        } else {
            try repository.save(product)
        }
    }
}
