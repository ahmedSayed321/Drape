//
//  ProductDetailsModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 07/07/2026.
//


enum ProductDetailsModuleFactory {
    @Environment(\.modelContext) private var context
    @MainActor
    static func makeProductDetailsView(productId: Int) -> ProductDetailsScreen {
        let localDataSource = SavedProductsLocalDataSourceImpl(context: context)
        let savedProductsRepository = SavedProductsRepositoryImpl(localDataSource: localDataSource)
        let toggleSaveUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)

        let viewModel = ProductDetailsViewModel(
            toggleSaveProductUseCase: toggleSaveUseCase
        )
        return ProductDetailsScreen(productId: productId, viewModel: viewModel)
    }
}
