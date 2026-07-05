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
        let localDataSource = SavedProductsLocalDataSourceImpl(context: modelContext)
        let savedProductsRepository = SavedProductsRepositoryImpl(localDataSource: localDataSource)

        let toggleUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)
        let getSavedUseCase = GetSavedProductsUseCase(repository: savedProductsRepository)

        let viewModel = BrandProductsViewModel(
            brandName: brand,
            toggleSaveProductUseCase: toggleUseCase,
            getSavedProductsUseCase: getSavedUseCase
        )
        return BrandProductsView(viewModel: viewModel)
    }
}
