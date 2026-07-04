//
//  PaymentMethodViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

@Observable
final class PaymentMethodViewModel {
    var cards: [CardItem] = [
        CardItem(id: UUID(), brand: "VISA", maskedNumber: "**** **** **** 2512", isDefault: true),
        CardItem(id: UUID(), brand: "Mastercard", maskedNumber: "**** **** **** 5421", isDefault: false),
        CardItem(id: UUID(), brand: "VISA", maskedNumber: "**** **** **** 2512", isDefault: false)
    ]

    var selectedCardID: UUID?

    var selectedCard: CardItem? {
        cards.first(where: { $0.id == selectedCardID })
    }

    var isApplyEnabled: Bool {
        selectedCard != nil
    }

    func selectCard(_ card: CardItem) {
        selectedCardID = card.id
    }
}
