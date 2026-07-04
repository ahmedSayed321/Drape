//
//  BrandProductsModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData


enum BrandProductsModuleFactory {
    @MainActor
    static func makeView(brand: String, modelContext: ModelContext) -> BrandProductsView {
        let savedProductsRepository = SavedProductsRepositoryImpl(context: modelContext)
        let toggleUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)

        let viewModel = BrandProductsViewModel(
            brandName: brand,
            toggleSaveProductUseCase: toggleUseCase,
            savedProductsRepository: savedProductsRepository
        )
        return BrandProductsView(viewModel: viewModel)
    }
}
