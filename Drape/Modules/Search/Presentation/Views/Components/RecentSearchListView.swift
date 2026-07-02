//
//  RecentSearchItemsListView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct RecentSearchListView: View {
    let recentSearches : [String]
    var onDelete: (String) -> Void

    var body: some View {
        ScrollView {
            VStack () {
                ForEach(recentSearches , id: \.self) { item in
                    RecentSearchItemView(title: item,onDelete: onDelete)
                    
                    Divider()
                        .foregroundStyle(Color(hex: "F0F0F0"))
                }
            }
        }
    }
}

#Preview {
    RecentSearchListView(recentSearches: ["Moaz"],onDelete: {_ in})
}
