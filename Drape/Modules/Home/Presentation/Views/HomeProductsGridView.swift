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
     
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(products) { product in
                HomeProductCard(product: product, onFavTap: {}, onCardTap: {})
                    .onAppear {
                        onProductAppear(product)
                    }
            }
        }
        
    }
}

#Preview {
    HomeProductsGridView(
        products: []
    )
}
