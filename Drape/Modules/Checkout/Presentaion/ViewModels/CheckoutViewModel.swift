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
    private let draftOrderId: String
    private var paymentAttemptCounter = 0

    
    // TODO: replace with real logged-in customer info from your auth/session store.
    private let customerFirstName: String
    private let customerLastName: String
    private let customerPhone: String?
    private let customerEmail: String
    
    private let customerId: Int
    
    init(cartItems: [CartItem] = [],
         draftOrderId: String,
         customerId: Int,
         customerFirstName: String = "Guest",
         customerLastName: String = "Customer",
         customerEmail: String = "customer@example.com",
         customerPhone: String? = nil,
         promoRepository: PromoCodeRepositoryProtocol = PromoCodeRepository(),
         checkoutRepository: CheckoutRepositoryProtocol = CheckoutRepository()
    ) {
        self.cartItems = cartItems
        self.draftOrderId = draftOrderId
        self.customerId = customerId
        self.customerFirstName = customerFirstName
        self.customerLastName = customerLastName
        self.customerEmail = customerEmail
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
    
    func makePaymobPaymentRequest() -> PaymentRequest? {
        guard state.isPlaceOrderEnabled, state.selectedAddress != nil else {
            state.errorMessage = "Please complete required checkout data."
            return nil
        }

        let amountCents = Int((state.total * 100).rounded())
        guard amountCents > 0 else {
            state.errorMessage = "Order total must be greater than zero."
            return nil
        }

        return PaymentRequest(
            amountCents: amountCents,
            currency: "EGP",
            merchantOrderId: makeUniqueMerchantOrderId(),
            billingData: PaymentBillingData(
                firstName: customerFirstName,
                lastName: customerLastName,
                email: customerEmail,
                phoneNumber: customerPhone ?? "01000000000"
            ),
            items: cartItems.map {
                PaymentItem(
                    name: $0.title,
                    amountCents: Int(($0.price * 100).rounded()),
                    description: $0.title,
                    quantity: $0.quantity
                )
            }
        )
    }

    private func makeUniqueMerchantOrderId() -> String {
        paymentAttemptCounter += 1

        let baseId = draftOrderId.isEmpty ? "drape" : draftOrderId
        let timestamp = Int(Date().timeIntervalSince1970)
        let randomSuffix = UUID().uuidString.prefix(8)

        return "\(baseId)-\(timestamp)-\(paymentAttemptCounter)-\(randomSuffix)"
    }

    func handlePaymentResult(_ result: PaymentResult) async {
        switch result {
        case .success:
            await placeOrder(financialStatus: "paid")
        case .failure(let message):
            state.errorMessage = message
        case .cancelled:
            state.errorMessage = "Payment was cancelled."
        }
    }

    func placeOrder(financialStatus: String = "pending") async {
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
            let order = try await checkoutRepository.createOrder(
                lineItems: cartItems,
                customerId: customerId,
                address: address,
                customerFirstName: customerFirstName,
                customerLastName: customerLastName,
                customerPhone: customerPhone,
                promo: state.appliedPromo,
                discountAmount: state.discountAmount,
                financialStatus: financialStatus,
                sendReceipt: true
            )
            print("✅ Order placed: \(order)")

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
