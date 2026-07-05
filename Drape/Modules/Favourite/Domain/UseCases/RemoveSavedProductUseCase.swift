//
//  RemoveSavedProductUseCaseProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 05/07/2026.
//


// Domain/UseCases/RemoveSavedProductUseCase.swift
protocol RemoveSavedProductUseCaseProtocol {
    func execute(productID: Int) throws
}

struct RemoveSavedProductUseCase: RemoveSavedProductUseCaseProtocol {
    let repository: SavedProductsRepository

    func execute(productID: Int) throws {
        try repository.remove(productID)
    }
}