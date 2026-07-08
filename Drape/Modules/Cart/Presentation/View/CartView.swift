//
//  CartView.swift
//  Drape
//
//  Created by Moaz on 03/07/2026.
//

import SwiftUI

struct CartView: View {
    @StateObject var viewModel: CartViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    var onBellTap: () -> Void = {}
    

    var body: some View {
        VStack(spacing: 0) {

            switch viewModel.state {
            case .loading:
                Spacer()
                ProgressView()
                Spacer()

            case .empty:
                Spacer()
                NoItemsInCart()
                Spacer()

            case .success(let cartUI):
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(cartUI.lineItems) { item in
                            CartLineItemRow(
                                item: item,
                                onIncrement: { viewModel.increment(item) },
                                onDecrement: { viewModel.decrement(item) },
                                onDelete: { Task { await viewModel.removeItem(item) } }
                            )
                        }
                    }
                    .padding(.top, 12)
                }
                .clipped()

                OrderSummaryView(
                    subtotal: cartUI.subtotal,
                    shipping: cartUI.shippingFee,
                    vat: cartUI.tax,
                    total: cartUI.total
                )
                .padding(.top, 8)

                CustomButton(
                    type: .primary,
                    text: "Go To Checkout",
                    action: {
                        let checkoutItems = cartUI.lineItems.map { item in
                            CartItem(
                                id: UUID(),
                                variantId: Int(item.id) ?? 0,
                                title: item.title,
                                price: NSDecimalNumber(decimal: item.priceDecimal).doubleValue,
                                quantity: item.quantity,
                                imageURL: item.imageURL
                            )
                        }
                        router.cartItems = checkoutItems
                        router.draftOrderId = viewModel.currentDraftOrderId ?? ""
                        router.showCheckout()
                    },
                    trailing: Image(systemName: "arrow.right")
                )
                .padding(.top, 16)
                .padding(.bottom, 8)

            case .failure(let message):
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundStyle(.secondary)
                    Text(message)
                        .font(.system(size: 16))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Try Again") {
                        Task { await viewModel.loadCart() }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onBellTap){
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("Cart")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
        .task {
            await viewModel.loadCart()
        }
    }
}

#Preview {
    CartView(viewModel: .live(draftOrderId: "1213139878074"))
}
