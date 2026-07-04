//
//  AddressView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI

struct AddressView: View {
    @Environment(AppRouter.self) private var router
    @State private var viewModel = AddressViewModel()
    let checkoutViewModel: CheckoutViewModel = CheckoutViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Saved Address")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 8)

                ForEach(viewModel.addresses) { address in
                    AddressRowView(
                        address: address,
                        isSelected: viewModel.selectedAddressID == address.id,
                        onTap: {
                            viewModel.selectAddress(address)
                        }
                    )
                }

                Button {
                    router.showAddAddress()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                        Text("Add New Address")
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
                        guard let address = viewModel.selectedAddress else { return }

                                checkoutViewModel.updateSelectedAddress(address)

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
                title: "Address",
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
    }
}
