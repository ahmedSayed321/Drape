//
//  NoResultsFoundStateView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct NoResultsFoundStateView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 52))
                .foregroundColor(Color(hex: "B3B3B3"))
                .padding(.bottom, 20)
            Text("No Results Found!")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 12)
            Text("Try a similar word or some more general ")
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color(hex: "808080"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 70)
    }
}

#Preview {
    NoResultsFoundStateView()
}
