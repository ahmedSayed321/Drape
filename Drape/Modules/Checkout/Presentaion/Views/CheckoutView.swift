//
//  CheckoutView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI

struct CheckoutView: View {
    @State private var viewModel = CheckoutViewModel()
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {

                StandardAppBar(
                    title: "Checkout",
                    trailingSystemImage: "bell",
                    onBackTapped: {
                        // TODO: wire up back navigation
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
                            Task { await viewModel.placeOrder() }
                        },
                        status: viewModel.state.isPlaceOrderEnabled ? .enable : .disable
                    )
                }
                .padding()
            }
            .background(Color.white)
            
            //TODO: Show order Success pop up
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
