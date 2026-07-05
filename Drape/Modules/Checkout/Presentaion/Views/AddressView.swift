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
    @State private var addressPendingDeletion: AddressItem?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Saved Address")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 8)
                
                if viewModel.addresses.isEmpty {
                    emptyAddressRow
                } else {
                    ForEach(viewModel.addresses) { address in
                        HStack(spacing: 12) {
                            AddressRowView(
                                address: address,
                                isSelected: viewModel.selectedAddressID == address.id,
                                onTap: {
                                    viewModel.selectAddress(address)
                                }
                            )
                            
                            // Delete button
                            Button {
                                addressPendingDeletion = address
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
                        router.selectedAddress = address
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
        .onAppear {
            viewModel.reload()
        }.alert(
            "Delete Address",
            isPresented: Binding(
                get: { addressPendingDeletion != nil },
                set: { if !$0 { addressPendingDeletion = nil } }
            ),
            presenting: addressPendingDeletion
        ) { address in
            Button("Delete", role: .destructive) {
                viewModel.deleteAddress(id: address.id)
                addressPendingDeletion = nil
            }
            Button("Cancel", role: .cancel) {
                addressPendingDeletion = nil
            }
        } message: { address in
            Text("Are you sure you want to delete this address?")
        }
    }
}

private extension AddressView {
    var emptyAddressRow: some View {
        HStack {
            Text("No address added")
                .foregroundStyle(.gray)

            Spacer()

            Button {
                router.showAddAddress()
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
