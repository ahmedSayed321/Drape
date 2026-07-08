//
//  BrandProductsEntryPoint.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftUI

struct BrandProductsEntryPoint: View {
    @Environment(\.modelContext) private var context
    let brand: String

    var body: some View {
        BrandProductsModuleFactory.makeView(brand: brand, modelContext: context)
    }
}
