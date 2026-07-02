//
//  SearchListView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

//struct TempSearchProduct: Identifiable {
//    var id: Int
//    let title: String
//    let price: String
//    let discount: String?   
//    let imageURL: String
//}

struct SearchListView: View {
//    let results: [TempSearchProduct]
    let results: [Product]
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
    }
}

#Preview {
    SearchListView(results: [] , onTap: {})
}
