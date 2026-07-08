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
        // Load persisted addresses/cards and set defaults
        let addresses = CheckoutStorage.shared.loadAddresses()
        let cards = CheckoutStorage.shared.loadCards()

        let selectedAddress = addresses.first(where: { $0.isDefault }) ?? addresses.first
        let selectedCard = cards.first(where: { $0.isDefault }) ?? cards.first

        self.state = CheckoutUiState(
            selectedAddress: selectedAddress,
            selectedPaymentOption: .card,
            selectedCard: selectedCard
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

    /// Update selected address from AddressViewModel selection
    func updateSelectedAddress(_ address: AddressItem) {
        state.selectedAddress = address
    }

    /// Update selected card from PaymentMethodViewModel selection
    func updateSelectedCard(_ card: CardItem) {
        state.selectedCard = card
    }
}
