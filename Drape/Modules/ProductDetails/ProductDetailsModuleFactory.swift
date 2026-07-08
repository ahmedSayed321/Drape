//
//  ProductDetailsModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 07/07/2026.
//

import SwiftUI
import SwiftData

enum ProductDetailsModuleFactory {
    @MainActor
    static func makeProductDetailsView(productId: Int, modelContext: ModelContext) -> ProductDetailsScreen {
        let localDataSource = SavedProductsLocalDataSourceImpl(context: modelContext)
        let savedProductsRepository = SavedProductsRepositoryImpl(localDataSource: localDataSource)
        let savedProductsUseCase = GetSavedProductsUseCase(repository: savedProductsRepository)
        let toggleSaveUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)

        let viewModel = ProductDetailsViewModel(
            toggleSaveProductUseCase: toggleSaveUseCase,
            getSavedProductsUseCase: savedProductsUseCase
        )
        return ProductDetailsScreen(viewModel: viewModel, productId: productId)
    }
}
