//
//  BrandProductsView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftUI

struct BrandProductsView: View {
    @StateObject var viewModel: BrandProductsViewModel
    @State private var showGuestAlert = false
    @Environment(\.dismiss) private var dismiss
    @Environment(AppRouter.self) private var router
    
    private let keychain = KeychainTokenStorage()

    var body: some View {
        VStack {
            BrandProductsTopBarView(
                title: viewModel.brandName,
                onBackTap: { dismiss() }
            )

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
                Spacer()
            } else if viewModel.products.isEmpty {
                EmptyProducts()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    HomeProductsGridView(
                        products: viewModel.products,
                        onProductAppear: { viewModel.loadMoreIfNeeded(currentItem: $0) },
                        isFavorited: { viewModel.isFavorited($0) },
                        onFavoriteTap: { product in
                            guard !isGuest else {
                                showGuestAlert = true
                                return
                            }
                            viewModel.toggleFavorite(product)
                        }
                    )
                    .padding(.top, 10)

                    if viewModel.isLoadingMore {
                        ProgressView().padding()
                    }
                }
                .clipped()
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.loadProductsOnce()
        }
        .onAppear {
            viewModel.refreshSavedState()
        }
        .alert("Login Required", isPresented: $showGuestAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Go to Login") {
                router.showSignIn()
            }
        } message: {
            Text("You need to login first to use favorites.")
        }
    }
    
    private var isGuest: Bool {
        guard let customerId = keychain.getShopifyCustomerID() else {
            return true
        }
        return customerId.isEmpty
    }
}
