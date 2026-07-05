//
//  ContentView.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            // First Tab
            HomeEntryPoint()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }.tag(0)
            
            // Second Tab
            FavoriteEntryPoint()
                .tabItem {
                    Label("Faourite", systemImage: "heart.fill")
                }.tag(1)
            
            // Third Tab
            CartView(viewModel: .live(draftOrderId: "1213139878074"))
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }.tag(2)
            
            // Fourth Tab
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }.tag(3)
        }
        .accentColor(.black)
}

}

#Preview {
    ContentView()
        .modelContainer(for: SavedProductModel.self, inMemory: true)
}
