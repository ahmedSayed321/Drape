//
//  FavouriteView.swift
//  Drape
//
//  Created by Me3bed on 03/07/2026.
//

import SwiftUI

struct FavouriteView: View {
    
    let sampleProducts: [Product] = [
        Product(
            id: 1,
            name: "Regular Fit Slogan",
            brand: "Drape",
            productType: "T-Shirt",
            price: "$ 1,190",
            imageUrl: "shirt1",
            sizes: ["S", "M", "L", "XL"]
        ),
        Product(
            id: 2,
            name: "Regular Fit Polo",
            brand: "Drape",
            productType: "Polo",
            price: "$ 1,190",
            imageUrl: "shirt2",
            sizes: ["M", "L", "XL"]
        ),
        Product(
            id: 3,
            name: "Regular Fit Black",
            brand: "Drape",
            productType: "Sleeveless",
            price: "$ 1,190",
            imageUrl: "shirt3",
            sizes: ["S", "M", "L"]
        ),
        Product(
            id: 4,
            name: "Regular Fit V-Neck",
            brand: "Drape",
            productType: "V-Neck",
            price: "$ 1,190",
            imageUrl: "shirt4",
            sizes: ["M", "L", "XL"]
        ),
        Product(
            id: 5,
            name: "Regular Fit Slogan",
            brand: "Drape",
            productType: "Long Sleeve",
            price: "$ 1,190",
            imageUrl: "shirt5",
            sizes: ["S", "M"]
        ),
        Product(
            id: 6,
            name: "Regular Fit Slogan",
            brand: "Drape",
            productType: "Long Sleeve",
            price: "$ 1,190",
            imageUrl: "shirt6",
            sizes: ["L", "XL", "XXL"]
        )
    ]
    
    var body: some View {
        VStack {
            FavoriteTopBarView()
            ScrollView(.vertical, showsIndicators: false) {
                FavoriteProductsGridView(products: sampleProducts)
                    .padding(.top, 10)
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    FavouriteView()
}
