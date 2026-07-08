//
//  HomeListView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 27/06/2026.
//

import SwiftUI

struct HomeProductsGridView: View {

    let products: [Product]
    var onProductAppear: (Product) -> Void = { _ in }
    var isFavorited: (Product) -> Bool = { _ in false }      // NEW
    var onFavoriteTap: (Product) -> Void = { _ in }          // NEW
     

    @State private var selectedProductId: Int?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {

        LazyVGrid(columns: columns, spacing: 20) {

            ForEach(products) { product in
                HomeProductCard(
                    uiState: product.toUIState(),
                    isFavorited: isFavorited(product),        // NEW
                    onFavTap: { onFavoriteTap(product) },      // NEW
                    onCardTap: {
                        selectedProductId = product.id
                    }
                )
                .onAppear {
                    onProductAppear(product)
                }
            }
        }
        .navigationDestination(item: $selectedProductId) { productId in
            ProductDetailsModuleFactory.makeProductDetailsView(productId: productId)
        }
    }
}
