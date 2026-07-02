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
        }
    }
}

#Preview {
}
