//
//  BrandProductsModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData


enum BrandProductsModuleFactory {
    @MainActor
    static func makeView(brand: Brand, modelContext: ModelContext) -> BrandProductsView {
        let savedProductsRepository = SavedProductsRepositoryImpl(context: modelContext)
        let toggleUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)
        let getSavedUseCase = GetSavedProductsUseCase(repository: savedProductsRepository)   // NEW

        let viewModel = BrandProductsViewModel(
            brandName: brand.name,
            toggleSaveProductUseCase: toggleUseCase,
            getSavedProductsUseCase: getSavedUseCase
        )
        return BrandProductsView(viewModel: viewModel)
    }
}
