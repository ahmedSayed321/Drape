//
//  EmptyOrdersView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import SwiftUI

struct EmptyOrdersView: View {
    let tab: OrdersScreen.Tab

    var body: some View {
        Spacer()

        VStack(spacing: 16) {
            Image(systemName: "shippingbox")
                .font(.system(size: 70, weight: .light))
                .foregroundColor(Color(.systemGray3))

            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)

            Text(subtitle)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.horizontal, 40)

        Spacer()
    }

    private var title: String {
        tab == .ongoing ? "No Ongoing Orders!" : "No Completed Orders!"
    }

    private var subtitle: String {
        tab == .ongoing
            ? "You don't have any ongoing orders\nat this time."
            : "You don't have any completed\norders yet."
    }
}
