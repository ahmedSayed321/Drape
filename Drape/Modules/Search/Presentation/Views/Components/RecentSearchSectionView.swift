//
//  RecentSearchSectionView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct RecentSearchSectionView: View {
    let recentSearches : [String]
    var onClearAll: () -> Void
    var onDelete: (String) -> Void
    
    var body: some View {
        RecentSearchHeaderView(onClearAll: onClearAll)
            .padding(.bottom, 20.0)
        RecentSearchListView(recentSearches: recentSearches,onDelete: onDelete)
    }
}

#Preview {
    RecentSearchSectionView(recentSearches: ["Jeans"],  onClearAll: {} , onDelete: {_ in})
}
