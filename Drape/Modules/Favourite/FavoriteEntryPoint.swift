//
//  FavoriteEntryPoint.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftUICore

struct FavoriteEntryPoint: View {
    @Environment(\.modelContext) private var context

    var body: some View {
        FavoriteModuleFactory.makeSavedProductsView(context: context)
    }
}
