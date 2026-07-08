//
//  AddCardView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI

struct AddCardView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = AddCardViewModel()

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Add Debit or Credit Card")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.top, 8)

                    CustomTextField(
                        title: "Card number",
                        placeHolder: "Enter your card number",
                        textFieldValue: Binding(
                            get: { viewModel.state.cardNumber },
                            set: { viewModel.updateCardNumber($0) }
                        ),
                        state: Binding(
                            get: { viewModel.state.cardNumberState },
                            set: { viewModel.state.cardNumberState = $0 }
                        )
                    )
                    .keyboardType(.numberPad)

                    HStack(spacing: 12) {
                        CustomTextField(
                            title: "Expiry Date",
                            placeHolder: "MM/YY",
                            textFieldValue: Binding(
                                get: { viewModel.state.expiryDate },
                                set: { viewModel.updateExpiryDate($0) }
                            ),
                            state: Binding(
                                get: { viewModel.state.expiryDateState },
                                set: { viewModel.state.expiryDateState = $0 }
                            )
                        )
                        .keyboardType(.numberPad)

                        CustomTextField(
                            title: "Security Code",
                            placeHolder: "CVC",
                            textFieldValue: Binding(
                                get: { viewModel.state.securityCode },
                                set: { viewModel.updateSecurityCode($0) }
                            ),
                            state: Binding(
                                get: { viewModel.state.securityCodeState },
                                set: { viewModel.state.securityCodeState = $0 }
                            )
                        )
                        .keyboardType(.numberPad)
                    }

                    Spacer(minLength: 28)

                    CustomButton(
                        type: .primary,
                        text: "Add Card",
                        action: {
                            viewModel.addCardTapped()
                        },
                        status: viewModel.state.isAddEnabled ? .enable : .disable
                    )
                    .padding(.top, 24)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }

            if viewModel.state.isSuccessVisible {
                successOverlay
            }
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            StandardAppBar(
                title: "New Card",
                trailingSystemImage: "bell",
                onBackTapped: {
                    router.showPayment()
                },
                onTrailingTapped: {}
            )
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private extension AddCardView {
    var successOverlay: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green)

                Text("Congratulations!")
                    .font(.title.bold())

                Text("Your new card has been added.")
                    .foregroundStyle(.secondary)

                CustomButton(
                    type: .primary,
                    text: "Thanks",
                    action: {
                        let card = viewModel.makeCardItem()
                        PaymentMethodViewModel.shared.addCard(card)
                        viewModel.dismissSuccess()
                        router.showPayment()
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
}
