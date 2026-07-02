//
//  VendorSectionView.swift
//  Drape
//
//  Created by Moaz on 30/06/2026.
//

import SwiftUI

struct BrandSectionView: View {
    let brands: [Brand]
    var onTap: () -> Void = {}
    var body: some View {
        VStack(alignment: .leading,spacing: 16.0) {
            HStack() {
                Text("Our Vendors")
                    .font(.system(size: 18.0,weight: .semibold))
                    .foregroundStyle(Color(hex: "121926"))
                
                Spacer()
                
                Button(action: onTap) {
                    Text("See All")
                        .font(.system(size: 16.0,weight: .regular))
                        .foregroundStyle(Color(hex: "B3B3B3"))
                }
                
            }
            
            BrandItemsList(brands: brands)
        }
    }
}

#Preview {
}
