//
//  GetSavedProductsUseCase.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 05/07/2026.
//

// Domain/UseCases/GetSavedProductsUseCase.swift
protocol GetSavedProductsUseCaseProtocol {
    func execute() throws -> [SavedProduct]
}

struct GetSavedProductsUseCase: GetSavedProductsUseCaseProtocol {
    let repository: SavedProductsRepository

    func execute() throws -> [SavedProduct] {
        try repository.getAll()
    }
}
