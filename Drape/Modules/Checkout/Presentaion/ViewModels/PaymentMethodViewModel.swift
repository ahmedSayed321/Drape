//
//  PaymentMethodViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation
@Observable
final class PaymentMethodViewModel {
    static let shared = PaymentMethodViewModel()

    var cards: [CardItem] = []
    var selectedCardID: UUID?

    init() {
        let stored = CheckoutStorage.shared.loadCards()
        if stored.isEmpty {
            cards = [
                CardItem(id: UUID(), brand: "VISA", maskedNumber: "**** **** **** 2512", isDefault: true)
            ]
            CheckoutStorage.shared.saveCards(cards)
        } else {
            cards = stored
        }
        selectedCardID = cards.first(where: { $0.isDefault })?.id
    }

    var selectedCard: CardItem? {
        cards.first(where: { $0.id == selectedCardID })
    }

    var isApplyEnabled: Bool {
        selectedCard != nil
    }

    func selectCard(_ card: CardItem) {
        selectedCardID = card.id
        cards = cards.map { c in
            CardItem(id: c.id, brand: c.brand, maskedNumber: c.maskedNumber, isDefault: c.id == card.id)
        }
        CheckoutStorage.shared.saveCards(cards)
    }

    func addCard(_ card: CardItem) {
        var newCard = card
        // First card added should become the default automatically
        if cards.isEmpty {
            newCard = CardItem(id: card.id, brand: card.brand, maskedNumber: card.maskedNumber, isDefault: true)
        }
        if newCard.isDefault {
            cards = cards.map { CardItem(id: $0.id, brand: $0.brand, maskedNumber: $0.maskedNumber, isDefault: false) }
        }
        cards.append(newCard)
        selectedCardID = newCard.isDefault ? newCard.id : selectedCardID
        CheckoutStorage.shared.saveCards(cards)
    }

    func deleteCard(id: UUID) {
        cards.removeAll { $0.id == id }
        CheckoutStorage.shared.saveCards(cards)
        if selectedCardID == id {
            selectedCardID = cards.first?.id
        }
    }
}
