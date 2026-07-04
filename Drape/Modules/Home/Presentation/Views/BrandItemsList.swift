//
//  VendorItemsList.swift
//  Drape
//
//  Created by Moaz on 30/06/2026.
//

import SwiftUI



struct BrandItemsList: View {
    let brands: [Brand]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(brands) { brand in
                    BrandItemView(brand: brand)
                }
            }
            .padding(.leading, 16) // Only leading on first item
            .padding(.trailing, 16) // Only trailing on last item
        }
    }
}

#Preview {
    BrandItemsList(
        brands: [
            Brand(
                id: 1,
                name: "Nike",
                imageUrl: nil
            ),
            Brand(
                id: 1,
                name: "Nike",
                imageUrl: nil
            ),
            Brand(
                id: 1,
                name: "Nike",
                imageUrl: nil
            )
        ]
    )
    .padding()
}
