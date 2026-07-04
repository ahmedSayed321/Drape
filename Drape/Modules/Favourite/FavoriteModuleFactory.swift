//
//  FavoriteModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftData

// Features/Favorite/FavoriteModuleFactory.swift
enum FavoriteModuleFactory {
    @MainActor
    static func makeSavedProductsView(context: ModelContext) -> FavouriteView {
        let repository = SavedProductsRepositoryImpl(context: context)
        let viewModel = SavedProductsViewModel(repository: repository)
        return FavouriteView(viewModel: viewModel)
    }
}
