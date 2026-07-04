//
//  UIStates.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

enum PaymentOption: String, CaseIterable, Identifiable {
    case card
    case cash
    case applePay

    var id: String { rawValue }
}

struct AddressItem: Identifiable, Equatable ,Hashable {
    let id: UUID
    let title: String
    let details: String
    let isDefault: Bool
}

struct CardItem: Identifiable, Equatable {
    let id: UUID
    let brand: String
    let maskedNumber: String
    let isDefault: Bool
}

struct CheckoutUiState {
    var selectedAddress: AddressItem?
    var selectedPaymentOption: PaymentOption = .card
    var selectedCard: CardItem?
    var promoCode: String = ""

    var subTotal: Double = 5870
    var vat: Double = 0
    var shippingFee: Double = 80

    var isApplyingPromo: Bool = false
    var isPlacingOrder: Bool = false
    var isOrderSuccessVisible: Bool = false
    var errorMessage: String?

    var total: Double {
        subTotal + vat + shippingFee
    }

    var isPromoButtonEnabled: Bool {
        !promoCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isApplyingPromo
    }

    var isPlaceOrderEnabled: Bool {
        guard selectedAddress != nil else { return false }

        switch selectedPaymentOption {
        case .card:
            return selectedCard != nil && !isPlacingOrder
        case .cash, .applePay:
            return !isPlacingOrder
        }
    }
}
