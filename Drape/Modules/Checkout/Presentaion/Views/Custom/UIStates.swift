//
//  UIStates.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation
import CoreLocation
import SwiftUI
import Observation

enum PaymentOption: String, CaseIterable, Identifiable {
    case card
    case cash
    case applePay

    var id: String { rawValue }
}

struct CardItem: Identifiable, Equatable, Codable {
    let id: UUID
    var brand: String
    var maskedNumber: String
    var isDefault: Bool
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
    
    var appliedPromo: ValidatedPromoCode?
    var discountAmount: Double = 0

    var total: Double {
        max(0, subTotal + vat + shippingFee - discountAmount)
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

struct AddAddressUiState {
    var nickname: String = ""
    var fullAddress: String = ""

    var nicknameState: TextFieldState = .normal
    var fullAddressState: TextFieldState = .normal

    var selectedCoordinate: CLLocationCoordinate2D?
    var isSaving: Bool = false
    var isSuccessVisible: Bool = false

    var isAddEnabled: Bool {
        !nickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !fullAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        selectedCoordinate != nil &&
        !isSaving
    }
}

struct PickedLocationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}


struct AddCardUiState {
    var cardNumber: String = ""
    var expiryDate: String = ""
    var securityCode: String = ""

    var cardNumberState: TextFieldState = .normal
    var expiryDateState: TextFieldState = .normal
    var securityCodeState: TextFieldState = .normal

    var isSaving: Bool = false
    var isSuccessVisible: Bool = false

    var isAddEnabled: Bool {
        cardNumberState == .success &&
        expiryDateState == .success &&
        securityCodeState == .success &&
        !isSaving
    }

    var cardNumberDigits: String {
        cardNumber.filter(\.isNumber)
    }
}

struct CartItem: Identifiable, Equatable {
    let id: UUID
    let variantId: Int
    let title: String
    let price: Double
    let quantity: Int
    let imageURL: URL?
}
extension Array where Element == CartItem {
    var subtotal: Double {
        reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }
}
