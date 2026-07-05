//
//  FavouriteView.swift
//  Drape
//
//  Created by Me3bed on 03/07/2026.
//

import SwiftUI

struct FavouriteView: View {
    
    @StateObject var viewModel: SavedProductsViewModel
    
    var body: some View {
        VStack {
            FavoriteTopBarView()
            ScrollView(.vertical, showsIndicators: false) {
                FavoriteProductsGridView(viewModel: viewModel)
                    .padding(.top, 10)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white.ignoresSafeArea())
        .onAppear {
            viewModel.loadProducts()
        }
    }
}

#Preview {
//    FavouriteView(
//        viewModel: SavedProductsViewModel(
//            repository: SavedProductsRepositoryImpl(
//                context:
//            )
//        )
//    )
}
