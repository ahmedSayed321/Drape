//
//  BrandProductsView.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import SwiftUI

struct BrandProductsView: View {
    @StateObject var viewModel: BrandProductsViewModel
    @Environment(\.dismiss) private var dismiss

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
                        onFavoriteTap: { viewModel.toggleFavorite($0) }
                    )
                    .padding(.top, 10)

                    if viewModel.isLoadingMore {
                        ProgressView().padding()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.loadProducts()
        }
    }
}
