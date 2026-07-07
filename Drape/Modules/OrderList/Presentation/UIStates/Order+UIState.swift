//
//  Order+UIState.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import SwiftUI

extension Order {
    func toUIState() -> OrderUIState {
        OrderUIState(
            id: id,
            name: name,
            statusText: fulfillmentStatus.statusText,
            statusColor: fulfillmentStatus.statusColor,
            showReviewButton: fulfillmentStatus == .fulfilled,
            lineItems: lineItems.map { $0.toUIState() }
        )
    }
}

extension OrderLineItem {
    func toUIState() -> OrderLineItemUIState {
        OrderLineItemUIState(
            id: id,
            title: title,
            sizeText: variantTitle.map { "Size: \($0)" },
            priceText: "$\(price)",
            imageURL: imageURL
        )
    }
}

extension FulfillmentStatus {
    var statusText: String {
        switch self {
        case .unfulfilled: return "Pending"
        case .partial: return "In Transit"
        case .fulfilled: return "Delivered"
        }
    }

    var statusColor: Color {
        switch self {
        case .unfulfilled: return .orange
        case .partial: return .blue
        case .fulfilled: return .green
        }
    }
}
