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
    
    private let promoRepository: PromoCodeRepositoryProtocol
    private let checkoutRepository: CheckoutRepositoryProtocol
    
    // TODO: replace with real cart data once the Cart feature exists.
    private var cartItems: [CartItem]
    
    // TODO: replace with real logged-in customer info from your auth/session store.
    private let customerFirstName: String
    private let customerLastName: String
    private let customerPhone: String?
    
    init(cartItems: [CartItem] = [],
         customerFirstName: String = "Guest",
         customerLastName: String = "Customer",
         customerPhone: String? = nil,
         promoRepository: PromoCodeRepositoryProtocol = PromoCodeRepository(),
         checkoutRepository: CheckoutRepositoryProtocol = CheckoutRepository()
    ) {
        self.cartItems = cartItems
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.customerPhone = customerPhone
        self.promoRepository = promoRepository
        self.checkoutRepository = checkoutRepository
        // Load persisted addresses/cards and set defaults
        let addresses = CheckoutStorage.shared.loadAddresses()
        let cards = CheckoutStorage.shared.loadCards()
        
        let selectedAddress = addresses.first(where: { $0.isDefault }) ?? addresses.first
        let selectedCard = cards.first(where: { $0.isDefault }) ?? cards.first
        
        self.state = CheckoutUiState(
            selectedAddress: selectedAddress,
            selectedPaymentOption: .card,
            selectedCard: selectedCard,
            subTotal: cartItems.subtotal
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
        
        let code = state.promoCode.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            let validated = try await promoRepository.validate(code: code)
            state.appliedPromo = validated
            state.discountAmount = calculateDiscountAmount(validated)
        } catch let error as PromoCodeError {
            state.appliedPromo = nil
            state.discountAmount = 0
            state.errorMessage = error.message
        } catch {
            state.appliedPromo = nil
            state.discountAmount = 0
            state.errorMessage = "Something went wrong. Please try again."
        }
        
        state.isApplyingPromo = false
    }
    
    private func calculateDiscountAmount(_ promo: ValidatedPromoCode) -> Double {
        switch promo.valueType {
        case "percentage":
            return state.subTotal * (promo.value / 100)
        case "fixed_amount":
            return promo.value
        default:
            return 0
        }
    }
    
    func placeOrder() async {
        guard state.isPlaceOrderEnabled else {
            state.errorMessage = "Please complete required checkout data."
            return
        }
        
        guard let address = state.selectedAddress else {
            state.errorMessage = "Please select a delivery address."
            return
        }
        
        state.isPlacingOrder = true
        state.errorMessage = nil
        
        do {
            let draftOrder = try await checkoutRepository.createDraftOrder(
                lineItems: cartItems,
                address: address,
                customerFirstName: customerFirstName,
                customerLastName: customerLastName,
                customerPhone: customerPhone,
                promo: state.appliedPromo
            )
            
            let paymentPending = state.selectedPaymentOption == .cash
            
            _ = try await checkoutRepository.completeOrder(
                draftOrderId: draftOrder.id,
                paymentPending: paymentPending
            )
            
            state.isOrderSuccessVisible = true
        } catch {
            state.errorMessage = "Couldn't place your order. Please try again."
        }
        
        state.isPlacingOrder = false
    }
    
    
    func dismissSuccess() {
        state.isOrderSuccessVisible = false
    }
    
    func updateSelectedAddress(_ address: AddressItem) {
        state.selectedAddress = address
    }
    
    func updateSelectedCard(_ card: CardItem) {
        state.selectedCard = card
    }
}
