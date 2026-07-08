//
//  SearchListView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct SearchListView: View {
    
    let results: [ProductSearch]
    let onTap: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(results) { product in
                    SearchItemView(
                        title: product.title,
                        price: product.price,
                        discount: product.discountPercentage,
                        imageURL: product.imageURL,
                        onTap: onTap
                    )

                    Divider()
                        .padding(.horizontal, 16)
                }
            }
        }
        .scrollIndicators(.hidden)
        .clipped()
    }
}

#Preview {
    SearchListView(results: [] , onTap: {})
}
