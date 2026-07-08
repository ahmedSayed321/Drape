//
//  ProductDetailsEntryPoint.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 07/07/2026.
//

import SwiftUI

struct ProductDetailsEntryPoint: View {
    @Environment(\.modelContext) private var context
    let productID: Int
    var body: some View {
        ProductDetailsModuleFactory.makeProductDetailsView(productId: productID, modelContext: context)
    }
}
