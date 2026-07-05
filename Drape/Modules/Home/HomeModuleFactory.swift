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
        let savedProductsRepository = SavedProductsRepositoryImpl(context: modelContext)
        let toggleUseCase = ToggleSaveProductUseCase(repository: savedProductsRepository)

        let viewModel = HomeViewModel(
            toggleSaveProductUseCase: toggleUseCase,
            savedProductsRepository: savedProductsRepository
        )
        return HomeScreen(viewModel: viewModel)
    }
}
