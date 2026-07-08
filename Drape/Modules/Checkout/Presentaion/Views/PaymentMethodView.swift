//
//  PaymentMethodView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI

struct PaymentMethodView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = PaymentMethodViewModel.shared
    @State private var cardPendingDeletion: CardItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Saved Cards")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 8)
                if viewModel.cards.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "creditcard")
                            .font(.system(size: 40))
                            .foregroundStyle(.gray)
                        Text("No saved cards yet")
                            .foregroundStyle(.gray)
                            .font(.subheadline)
                        Button(action: { router.showAddCard() }) {
                            Text("Add a card")
                                .fontWeight(.medium)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
                } else {
                    ForEach(viewModel.cards) { card in
                        HStack(spacing: 12) {
                            PaymentCardRowView(
                                card: card,
                                isSelected: viewModel.selectedCardID == card.id,
                                onTap: {
                                    viewModel.selectCard(card)
                                }
                            )

                            // Delete button
                            Button {
                                cardPendingDeletion = card
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 14))
                            }
                            .padding(.trailing, 8)
                        }
                    }
                }

                Button {
                    router.showAddCard()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Add New Card")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3))
                    }
                }
                .padding(.top, 8)

                Spacer(minLength: 24)

                CustomButton(
                    type: .primary,
                    text: "Apply",
                    action: {
                        guard let card = viewModel.selectedCard else { return }
                        router.selectedCard = card
                        router.showCheckout()
                    },
                    status: viewModel.isApplyEnabled ? .enable : .disable
                )
                .padding(.top, 24)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .safeAreaInset(edge: .top, spacing: 0) {
            StandardAppBar(
                title: "Payment Method",
                trailingSystemImage: "bell",
                onBackTapped: {
                    router.showCheckout()
                },
                onTrailingTapped: {}
            )
            .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .alert(
             "Delete Card",
             isPresented: Binding(
                 get: { cardPendingDeletion != nil },
                 set: { if !$0 { cardPendingDeletion = nil } }
             ),
             presenting: cardPendingDeletion
         ) { card in
             Button("Delete", role: .destructive) {
                 viewModel.deleteCard(id: card.id)
                 cardPendingDeletion = nil
             }
             Button("Cancel", role: .cancel) {
                 cardPendingDeletion = nil
             }
         } message: { card in
             Text("Are you sure you want to delete \(card.brand) ending in \(card.maskedNumber.suffix(4))?")
         }
     }
 }

import SwiftUI

struct PaymentCardRowView: View {
    let card: CardItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                HStack(spacing: 10) {
                    Text(card.brand)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.black)

                    Text(card.maskedNumber)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black)

                    if card.isDefault {
                        Text("Default")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(isSelected ? .black : .gray.opacity(0.5), lineWidth: 1.5)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(.black)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 52)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25))
            }
        }
        .buttonStyle(.plain)
    }
}
