//
//  BrandProductsTopBarView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//


//
//  BrandProductsTopBarView.swift
//  Drape
//

import SwiftUI

struct BrandProductsTopBarView: View {
    let title: String
    var onBackTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBackTap) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }

                Spacer()

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                // invisible spacer to balance the back button's width, keeps title centered
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.clear)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    BrandProductsTopBarView(title: "Adidas")
}