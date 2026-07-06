//
//  FavoriteModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData

enum FavoriteModuleFactory {
    @MainActor
    static func makeSavedProductsView(context: ModelContext) -> FavouriteView {
        let localDataSource = SavedProductsLocalDataSourceImpl(context: context)
        let repository = SavedProductsRepositoryImpl(localDataSource: localDataSource)

        let viewModel = SavedProductsViewModel(
            getSavedProductsUseCase: GetSavedProductsUseCase(repository: repository),
            removeSavedProductUseCase: RemoveSavedProductUseCase(repository: repository)
        )
        return FavouriteView(viewModel: viewModel)
    }
}
