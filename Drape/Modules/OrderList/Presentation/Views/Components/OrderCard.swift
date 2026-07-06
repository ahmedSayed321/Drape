//
//  OrderCard.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import SwiftUI

struct OrderCard: View {
    let order: Order
    var onLeaveReviewTap: (OrderLineItem) -> Void = { _ in }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            header

            Divider()

            VStack(spacing: 12) {
                ForEach(order.lineItems) { item in
                    OrderLineItemRow(
                        item: item,
                        showReviewButton: order.fulfillmentStatus == .fulfilled,
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
        Text(statusText)
            .font(.system(size: 11, weight: .semibold))
            .foregroundColor(statusColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.15))
            .clipShape(Capsule())
    }

    private var statusText: String {
        switch order.fulfillmentStatus {
        case .unfulfilled: return "Pending"
        case .partial: return "In Transit"
        case .fulfilled: return "Delivered"
        }
    }

    private var statusColor: Color {
        switch order.fulfillmentStatus {
        case .unfulfilled: return .orange
        case .partial: return .blue
        case .fulfilled: return .green
        }
    }
}
