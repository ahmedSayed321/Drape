//
//  OrderUIState.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import SwiftUI

struct OrderUIState: Identifiable {
    let id: Int
    let name: String
    let statusText: String
    let statusColor: Color
    let showReviewButton: Bool
    let lineItems: [OrderLineItemUIState]
}

struct OrderLineItemUIState: Identifiable {
    let id: Int
    let title: String
    let sizeText: String?
    let priceText: String
    let imageURL: String?
}
