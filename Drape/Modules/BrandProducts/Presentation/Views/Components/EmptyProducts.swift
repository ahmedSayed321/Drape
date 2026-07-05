//
//  EmptyProducts.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//


//
//  EmptyProducts.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//
import SwiftUI

struct EmptyProducts: View {
    var body: some View {
        Spacer()

        VStack(spacing: 16) {
            Image(systemName: "bag")
                .font(.system(size: 70, weight: .light))
                .foregroundColor(Color(.systemGray3))

            Text("No Products Found!")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text("This vendor doesn't have any\nproducts available right now.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 40)

        Spacer()
    }
}

#Preview {
    EmptyProducts()
}