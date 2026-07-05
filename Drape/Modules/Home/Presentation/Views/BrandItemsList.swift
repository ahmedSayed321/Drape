//
//  VendorItemsList.swift
//  Drape
//
//  Created by Moaz on 30/06/2026.
//

import SwiftUI

extension Brand: Hashable {
    static func == (lhs: Brand, rhs: Brand) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

struct BrandItemsList: View {
    let brands: [Brand]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(brands) { brand in
                    NavigationLink(value: brand) {
                        BrandItemView(brand: brand)
                    }
                    .buttonStyle(.plain)   // prevents default blue tint / button styling on the whole tile
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
