//
//  FavoriteProductsGridView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 03/07/2026.
//

import SwiftUI

struct FavoriteProductsGridView: View {
    let viewModel: SavedProductsViewModel
    
    @State private var selectedProductId: Int?
     
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.products) { product in
                HomeProductCard(
                    uiState: product.toUIState(),
                    isFavorited: true,
                    onFavTap: {
                        viewModel.remove(product)
                    },
                    onCardTap: {
                        selectedProductId = product.id
                    }
                )
            }
        }
        .navigationDestination(item: $selectedProductId) { productId in
            ProductDetailsEntryPoint(productID: productId)
        }
        
    }
}

#Preview {
    FavoriteEntryPoint()
}
