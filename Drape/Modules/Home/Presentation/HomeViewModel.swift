//
//  HomeViewModel.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

// Ensure all UI updates happen safely on the main thread
@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    @Published var brands: [Brand] = []
    @Published var categories: [String] = ["All"]
    @Published var selectedCategory: String = "All"
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoadingMore: Bool = false
    @Published var savedProductIDs: Set<Int> = []
    
    @Published var sortOption: SortOption = .relevance
    @Published var priceRange: ClosedRange<Double> = 0...200
    @Published var selectedSizes: Set<String> = []
    
    private var hasLoadedData = false
    
    // MARK: - Featured Carousel
    // Static mock banners shown in the auto-scrolling home carousel.
    // Not derived from `products` since `Product` has no real "post link" yet.
    // Initialized directly from the static mock data — no network fetch needed.
    @Published var featuredProducts: [BannerProduct] = BannerProduct.mockBanners
    
    var maxProductPrice: Double {
            max(products.map(\.priceValue).max() ?? 200, 1)
    }

    var availableSizes: [String] {
        let scoped = selectedCategory == "All"
            ? products
            : products.filter { $0.productType == selectedCategory }

        let allSizes = Set(scoped.flatMap(\.sizes))
        return allSizes.sorted(by: Self.sizeSort)
    }
    
    private static let letterSizeOrder = ["XXS", "XS", "S", "M", "L", "XL", "XXL", "XXXL"]
    
    
    var filteredProducts: [Product] {
        var result = products

        if selectedCategory != "All" {
            result = result.filter { $0.productType == selectedCategory }
        }

        result = result.filter { priceRange.contains($0.priceValue) }

        if !selectedSizes.isEmpty {
            result = result.filter { !Set($0.sizes).isDisjoint(with: selectedSizes) }
        }

        switch sortOption {
        case .relevance:
            break
        case .priceLowHigh:
            result.sort { $0.priceValue < $1.priceValue }
        case .priceHighLow:
            result.sort { $0.priceValue > $1.priceValue }
        }

        return result
    }
    
    private let pageSize = 20
    private var canLoadMore = true // becomes false once Shopify returns fewer items than requested
    
    private let getHomeScreenDataUseCase: GetHomeScreenDataUseCaseProtocol
    private let loadMoreProductsUseCase: LoadMoreProductsUseCaseProtocol
    private let toggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol
    private let getSavedProductsUseCase: GetSavedProductsUseCaseProtocol
    
    init(
        getHomeScreenDataUseCase: GetHomeScreenDataUseCaseProtocol = GetHomeScreenDataUseCase(),
        loadMoreProductsUseCase: LoadMoreProductsUseCaseProtocol = LoadMoreProductsUseCase(),
        toggleSaveProductUseCase: ToggleSaveProductUseCaseProtocol,
        getSavedProductsUseCase: GetSavedProductsUseCaseProtocol
    ) {
        self.getHomeScreenDataUseCase = getHomeScreenDataUseCase
        self.loadMoreProductsUseCase = loadMoreProductsUseCase
        self.toggleSaveProductUseCase = toggleSaveProductUseCase
        self.getSavedProductsUseCase = getSavedProductsUseCase
    }
    
    func loadHomeDataOnce() async {
        guard !hasLoadedData else { return }
        
        isLoading = true
        errorMessage = nil

        do {
            // 1. Fetch the single response struct
            let homeData = try await getHomeScreenDataUseCase.execute()
            
            // 2. Map the properties directly onto your published fields
            self.products = homeData.products
            self.brands = homeData.brands
            self.categories = ["All"] + homeData.categories

            self.canLoadMore = homeData.products.count == pageSize
            priceRange = 0...maxProductPrice
//            priceRange = 0...3_000
            
            refreshSavedState()

            hasLoadedData = true
            
            isLoading = false
        } catch {
            errorMessage = "Failed to load data \(error.localizedDescription)"
            isLoading = false
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
            print("Entered toggle")
            try toggleSaveProductUseCase.execute(product: product.toSavedProduct())
            refreshSavedState()
        } catch {
            errorMessage = "Failed to update favorites: \(error.localizedDescription)"
        }
    }
    
    private static func sizeSort(_ lhs: String, _ rhs: String) -> Bool {
        if let l = Double(lhs), let r = Double(rhs) {
            return l < r
        }

        if let li = letterSizeOrder.firstIndex(of: lhs.uppercased()),
           let ri = letterSizeOrder.firstIndex(of: rhs.uppercased()) {
            return li < ri
        }

        return lhs.localizedStandardCompare(rhs) == .orderedAscending
    }
        
    private var isFilteringActive: Bool {
        selectedCategory != "All"
            || priceRange != (0...maxProductPrice)
            || !selectedSizes.isEmpty
//        selectedCategory != "All"
//            || priceRange != (0...3_000)
//            || !selectedSizes.isEmpty
    }
        
    /// Call this when the user scrolls near the bottom.
    func loadMoreProductsIfNeeded(currentItem product: Product) {
        guard !isFilteringActive else { return }
        // Trigger when the user reaches the last few displayed products
        guard let index = products.firstIndex(where: { $0.id == product.id }) else { return }
        let thresholdIndex = products.index(products.endIndex, offsetBy: -3, limitedBy: products.startIndex) ?? products.startIndex
        guard index >= thresholdIndex else { return }
        
        Task { await loadMoreProducts() }
    }
    
    func loadMoreProducts() async {
        guard !isLoadingMore, !isLoading, canLoadMore else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }
        
        let requestLimit = products.count + pageSize
        
        do {
            let refetched = try await loadMoreProductsUseCase.execute(limit: requestLimit)
            
            // Nothing new came back -> we've hit the end of the catalog
            guard refetched.count > products.count else {
                canLoadMore = false
                return
            }
            
            // Drop the ones already displayed, append only the new tail
            let newProducts = Array(refetched.suffix(from: products.count))
            products.append(contentsOf: newProducts)
            
            // Shopify returned fewer than requested -> no more pages left
            if refetched.count < requestLimit {
                canLoadMore = false
            }
        } catch {
            errorMessage = "Failed to load more products: \(error.localizedDescription)"
        }
    }
}
