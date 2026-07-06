//
//  HomeModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData


enum HomeModuleFactory {
    @MainActor
    static func makeHomeView(modelContext: ModelContext) -> HomeScreen {
        let localDataSource = SavedProductsLocalDataSourceImpl(context: modelContext)   // NEW
        let savedProductsRepository = SavedProductsRepositoryImpl(localDataSource: localDataSource)   // CHANGED

        let toggleUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)
        let getSavedUseCase = GetSavedProductsUseCase(repository: savedProductsRepository)

        let viewModel = HomeViewModel(
            toggleSaveProductUseCase: toggleUseCase,
            getSavedProductsUseCase: getSavedUseCase
        )
        return HomeScreen(viewModel: viewModel)
    }
}
