//
//  RecentSearchHeaderView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct RecentSearchHeaderView: View {
    var onClearAll: () -> Void
    var body: some View {
        HStack {
            Text("Recent Searches")
                .font(.system(size: 20, weight: .semibold))
            Spacer()
            Button(action: onClearAll) {
                Text("Clear all")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color(hex: "1A1A1A"))
                    .underline()
            }
            .buttonStyle(.plain)
                
        }
    }
}

#Preview {
    RecentSearchHeaderView(onClearAll: {})
}
