//
//  CheckoutViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

@Observable
final class CheckoutViewModel {
    var state: CheckoutUiState

    init() {
        let address = AddressItem(
            id: UUID(),
            title: "Home",
            details: "925 S Chugach St #APT 10, Alaska 99645",
            isDefault: true
        )

        let card = CardItem(
            id: UUID(),
            brand: "VISA",
            maskedNumber: "**** **** **** 2512",
            isDefault: true
        )

        self.state = CheckoutUiState(
            selectedAddress: address,
            selectedPaymentOption: .card,
            selectedCard: card
        )
    }

    func selectPaymentOption(_ option: PaymentOption) {
        state.selectedPaymentOption = option

        if option != .card {
            state.errorMessage = nil
        }
    }

    func updatePromoCode(_ code: String) {
        state.promoCode = code
    }

    func applyPromo() async {
        guard state.isPromoButtonEnabled else { return }

        state.isApplyingPromo = true
        state.errorMessage = nil

        try? await Task.sleep(nanoseconds: 800_000_000)

        let code = state.promoCode.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if code == "save10" {
            state.subTotal -= 10
        } else {
            state.errorMessage = "Invalid promo code"
        }

        state.isApplyingPromo = false
    }

    func placeOrder() async {
        guard state.isPlaceOrderEnabled else {
            state.errorMessage = "Please complete required checkout data."
            return
        }

        state.isPlacingOrder = true
        state.errorMessage = nil

        try? await Task.sleep(nanoseconds: 1_000_000_000)

        state.isPlacingOrder = false
        state.isOrderSuccessVisible = true
    }

    func dismissSuccess() {
        state.isOrderSuccessVisible = false
    }
}
