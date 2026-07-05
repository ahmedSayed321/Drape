//
//  BrandProductsViewModel.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//

import Combine


@MainActor
final class BrandProductsViewModel: ObservableObject {

    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var savedProductIDs: Set<Int> = []

    let brandName: String

    private let pageSize = 20
    private var canLoadMore = true
    private let getProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol
    private let toggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol
    private let getSavedProductsUseCase: GetSavedProductsUseCaseProtocol

    init(
        brandName: String,
        getProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol = GetProductsByVendorUseCase(),
        toggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol,
        getSavedProductsUseCase: GetSavedProductsUseCaseProtocol
    ) {
        self.brandName = brandName
        self.getProductsByVendorUseCase = getProductsByVendorUseCase
        self.toggleSaveProductUseCase = toggleSaveProductUseCase
        self.getSavedProductsUseCase = getSavedProductsUseCase
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await getProductsByVendorUseCase.execute(vendor: brandName, limit: pageSize)
            products = fetched
            canLoadMore = fetched.count == pageSize
            refreshSavedState()
        } catch {
            errorMessage = "Failed to load \(brandName) products: \(error.localizedDescription)"
        }
        isLoading = false
    }

    func loadMoreIfNeeded(currentItem product: Product) {
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        let thresholdIndex = products.index(products.endIndex, offsetBy: -3, limitedBy: products.startIndex) ?? products.startIndex
        guard index >= thresholdIndex else { return }
        Task { await loadMore() }
    }

    private func loadMore() async {
        guard !isLoadingMore, !isLoading, canLoadMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        let requestLimit = products.count + pageSize
        do {
            let refetched = try await getProductsByVendorUseCase.execute(vendor: brandName, limit: requestLimit)
            guard refetched.count > products.count else {
                canLoadMore = false
                return
            }
            let newProducts = Array(refetched.suffix(from: products.count))
            products.append(contentsOf: newProducts)
            if refetched.count < requestLimit {
                canLoadMore = false
            }
            refreshSavedState()
        } catch {
            errorMessage = "Failed to load more: \(error.localizedDescription)"
        }
    }

    func refreshSavedState() {
        guard let ids = try? getSavedProductsUseCase.execute().map(\.id) else { return }
        savedProductIDs = Set(ids)
    }

    func isFavorited(_ product: Product) -> Bool {
        savedProductIDs.contains(product.id)
    }

    func toggleFavorite(_ product: Product) {
        do {
            try toggleSaveProductUseCase.execute(product: product.toSavedProduct())
            refreshSavedState()
        } catch {
            errorMessage = "Failed to update favorites: \(error.localizedDescription)"
        }
    }
}
