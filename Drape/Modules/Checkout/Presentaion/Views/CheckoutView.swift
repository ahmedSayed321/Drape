//
//  CheckoutView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI

struct CheckoutView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel: CheckoutViewModel
    @State private var isConfirmationVisible = false
    @State private var paymentRequest: PaymentRequest?
    @State private var isPaymobPaymentPresented = false

    init(cartItems: [CartItem], draftOrderId: String) {
        let tokenStorage = KeychainTokenStorage()
        let customerId = tokenStorage.getShopifyCustomerID().flatMap { Int($0) } ?? 0
        _viewModel = State(initialValue: CheckoutViewModel(cartItems: cartItems, draftOrderId: draftOrderId, customerId: customerId )
        )
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {

                StandardAppBar(
                    title: "Checkout",
                    trailingSystemImage: "bell",
                    onBackTapped: {
                        router.showCart()
                    },
                    onTrailingTapped: { }
                )

                VStack(alignment: .leading, spacing: 20) {
                    addressSection
                    Divider()
                    paymentSection
                    Divider()
                    summarySection
                    Divider()
                    promoSection
                    Spacer()
                    CustomButton(
                        type: .primary,
                        text: viewModel.state.isPlacingOrder ? "Placing..." : "Place Order",
                        action: {
                            isConfirmationVisible = true
                        },
                        status: viewModel.state.isPlaceOrderEnabled ? .enable : .disable
                    )
                }
                .padding()
            }
            .background(Color.white)
            .onChange(of: router.currentScreen) { _, newScreen in
                guard newScreen == .checkout else { return }
                if let address = router.selectedAddress {
                    viewModel.updateSelectedAddress(address)
                }
                if let card = router.selectedCard {
                    viewModel.updateSelectedCard(card)
                }
            }
            
            if isConfirmationVisible {
                confirmationOverlay
            }
            
            
            if viewModel.state.isOrderSuccessVisible {
                successOverlay
            }
        }
        .fullScreenCover(isPresented: $isPaymobPaymentPresented) {
            if let paymentRequest {
                PaymentModuleFactory.makePaymentView(paymentRequest: paymentRequest, method: .paymob) { result in
                    isPaymobPaymentPresented = false
                    Task {
                        await viewModel.handlePaymentResult(result)
                    }
                }
            }
        }
    }
}

private extension CheckoutView {
    var addressSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Delivery Address")
                    .font(.headline)

                Spacer()

                Button("Change") {
                    router.showAddress()                }
                .underline()
                .foregroundStyle(.black)
            }

            if let address = viewModel.state.selectedAddress {
                VStack(alignment: .leading, spacing: 4) {
                    Text(address.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text(address.details)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
        }
    }

    var paymentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Method")
                .font(.headline)

            HStack(spacing: 8) {
                paymentChip(title: "Card", option: .card)
                paymentChip(title: "Cash", option: .cash)
                paymentChip(title: "Apple Pay", option: .applePay)
            }

            if viewModel.state.selectedPaymentOption == .card {
                HStack {
                    if let card = viewModel.state.selectedCard {
                        Text("\(card.brand)  \(card.maskedNumber)")
                            .fontWeight(.medium)
                    } else {
                        Text("No card added")
                            .foregroundStyle(.gray)
                    }

                    Spacer()

                    Button {
                        router.showPayment()
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundStyle(.black)
                    }
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3))
                }
            }
        }
    }

    func paymentChip(title: String, option: PaymentOption) -> some View {
        let isSelected = viewModel.state.selectedPaymentOption == option

        return Button {
            viewModel.selectPaymentOption(option)
        } label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? .white : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(isSelected ? Color.black : Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.black : Color.gray.opacity(0.3))
                }
                .cornerRadius(10)
        }
    }

    var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Summary")
                .font(.headline)
            
            summaryRow(title: "Sub-total", value: viewModel.state.subTotal)
            summaryRow(title: "VAT (%)", value: viewModel.state.vat)
            summaryRow(title: "Shipping fee", value: viewModel.state.shippingFee)
            if viewModel.state.discountAmount > 0 {
                HStack {
                    Text("Discount")
                        .foregroundStyle(.gray)
                    
                    Spacer()
                    
                    Text("- $ \(Int(viewModel.state.discountAmount))")
                        .foregroundStyle(.green)
                }
            }
            summaryRow(title: "Total", value: viewModel.state.total, isBold: true)
        }
    }

    func summaryRow(title: String, value: Double, isBold: Bool = false) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(isBold ? .black : .gray)

            Spacer()

            Text("$ \(Int(value))")
                .fontWeight(isBold ? .bold : .regular)
        }
    }

    var promoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                TextField("Enter promo code", text: Binding(
                    get: { viewModel.state.promoCode },
                    set: { viewModel.updatePromoCode($0) }
                ))
                .padding(.horizontal, 12)
                .frame(height: 52)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3))
                }

                CustomButton(
                    type: .primary,
                    text: viewModel.state.isApplyingPromo ? "..." : "Add",
                    action: {
                        Task { await viewModel.applyPromo() }
                    },
                    status: viewModel.state.isPromoButtonEnabled ? .enable : .disable
                )
                .frame(width: 90)
            }

            if let error = viewModel.state.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
    }
}
private extension CheckoutView {
    
    var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green)

                Text("Order Placed!")
                    .font(.title.bold())

                Text("Your order has been placed successfully.")
                    .foregroundStyle(.secondary)

                CustomButton(
                    type: .primary,
                    text: "Thanks",
                    action: {
                        viewModel.dismissSuccess()
                        router.showHome()
                        let keychain = KeychainTokenStorage()
                        keychain.clearCartDraftOrderID()
                    },
                    status: .enable
                )
            }
            .padding(28)
            .frame(width: 320)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 20)
        }
        .zIndex(100)
    }
    
    var confirmationOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Confirm Your Order")
                    .font(.title2.bold())

                VStack(alignment: .leading, spacing: 8) {
                    confirmationRow(
                        label: "Deliver to",
                        value: viewModel.state.selectedAddress?.title ?? "No address selected"
                    )

                    if let address = viewModel.state.selectedAddress {
                        Text(address.details)
                            .font(.footnote)
                            .foregroundStyle(.gray)
                            .padding(.leading, 2)
                    }

                    Divider()

                    confirmationRow(
                        label: "Payment",
                        value: paymentSummaryText
                    )

                    Divider()

                    confirmationRow(
                        label: "Total",
                        value: "$ \(Int(viewModel.state.total))",
                        isBold: true
                    )
                }
                .padding(.vertical, 4)

                HStack(spacing: 12) {
                    CustomButton(
                        type: .custom(textColor: .white, buttonColor: .red),
                        text: "Cancel",
                        action: {
                            isConfirmationVisible = false
                        },
                        status: .enable
                    )

                    CustomButton(
                        type: .primary,
                        text: "Confirm",
                        action: {
                            isConfirmationVisible = false
                            switch viewModel.state.selectedPaymentOption {
                            case .card:
                                if let request = viewModel.makePaymobPaymentRequest() {
                                    paymentRequest = request
                                    isPaymobPaymentPresented = true
                                }
                            case .cash:
                                Task { await viewModel.placeOrder() }
                            case .applePay:
                                viewModel.state.errorMessage = "Apple Pay is not available yet."
                            }
                        },
                        status: .enable
                    )
                }
            }
            .padding(28)
            .frame(width: 320)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 20)
        }
        .zIndex(99)
    }

    func confirmationRow(label: String, value: String, isBold: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.gray)

            Text(value)
                .font(isBold ? .headline : .subheadline)
                .fontWeight(isBold ? .bold : .medium)
        }
    }

    var paymentSummaryText: String {
        switch viewModel.state.selectedPaymentOption {
        case .card:
            if let card = viewModel.state.selectedCard {
                return "\(card.brand) \(card.maskedNumber)"
            }
            return "No card added"
        case .cash:
            return "Cash on Delivery"
        case .applePay:
            return "Apple Pay"
        }
    }
}
