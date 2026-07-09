//
//  ContentView.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppRouter.self) private var router
    @State private var isChatPresented = false

    var body: some View {
        @Bindable var router = router
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $router.selectedTab) {
                HomeEntryPoint()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)

                FavoriteEntryPoint()
                    .tabItem { Label("Faourite", systemImage: "heart.fill") }
                    .tag(1)

                CartView(viewModel: .live(draftOrderId: router.draftOrderId.isEmpty ? nil : router.draftOrderId))
                    .tabItem { Label("Cart", systemImage: "cart.fill") }
                    .tag(2)

                AccountView()
                    .tabItem { Label("Account", systemImage: "person.fill") }
                    .tag(3)
            }
            .accentColor(.black)

            if router.selectedTab == 0 {
                ChatFAB {
                    isChatPresented = true
                }
                .padding(.trailing, 20)
                .padding(.bottom, 70)
            }
        }
        .sheet(isPresented: $isChatPresented) {
            ChatView()
        }
    }
}

#Preview {
    ContentView()
        .environment(AppRouter())
        .modelContainer(for: SavedProductModel.self, inMemory: true)
}
