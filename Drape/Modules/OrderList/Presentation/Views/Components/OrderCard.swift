//
//  OrderCard.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import SwiftUI

struct OrderCard: View {
    let order: OrderUIState
    var onLeaveReviewTap: (OrderLineItemUIState) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            Divider()

            VStack(spacing: 12) {
                ForEach(order.lineItems) { item in
                    OrderLineItemRow(
                        item: item,
                        showReviewButton: order.showReviewButton,
                        onLeaveReviewTap: { onLeaveReviewTap(item) }
                    )
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var header: some View {
        HStack {
            Text(order.name)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            statusBadge
        }
    }

    private var statusBadge: some View {
        Text(order.statusText)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(order.statusColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(order.statusColor.opacity(0.15))
            .clipShape(Capsule())
    }
}

#Preview {
    OrderCard(
        order: OrderUIState(
            id: 1,
            name: "#1015",
            statusText: "Delivered",
            statusColor: .green,
            showReviewButton: true,
            lineItems: [
                OrderLineItemUIState(
                    id: 1,
                    title: "Regular Fit Slogan",
                    sizeText: "Size: M",
                    priceText: "$129.95",
                    imageURL: nil
                )
            ]
        )
    )
    .padding()
}
