//
//  ContentView.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    @State private var isChatPresented = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $selectedTab) {
                HomeEntryPoint()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)

                FavoriteEntryPoint()
                    .tabItem { Label("Faourite", systemImage: "heart.fill") }
                    .tag(1)

                CartView(viewModel: .live(draftOrderId: "1213139878074"))
                    .tabItem { Label("Cart", systemImage: "cart.fill") }
                    .tag(2)

                AccountView()
                    .tabItem { Label("Account", systemImage: "person.fill") }
                    .tag(3)
            }
            .accentColor(.black)

            if selectedTab == 0 {
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
        .modelContainer(for: SavedProductModel.self, inMemory: true)
}
