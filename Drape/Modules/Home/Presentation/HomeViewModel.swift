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
    
    @Published var sortOption: SortOption = .relevance
    @Published var priceRange: ClosedRange<Double> = 0...200
    @Published var selectedSizes: Set<String> = []
    
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
    
    private let getAllProductsUseCase: GetAllProductsUseCase
    private let getAllBrandsUseCase: GetAllBrandsUseCase
    private let getAllCategories: GetAllCategoriesUseCase
    
    init(
        getAllProductsUseCase: GetAllProductsUseCase = GetAllProductsUseCase(),
        getAllBrandsUseCase: GetAllBrandsUseCase = GetAllBrandsUseCase(),
        getAllCategories: GetAllCategoriesUseCase = GetAllCategoriesUseCase()
    ) {
        self.getAllProductsUseCase = getAllProductsUseCase
        self.getAllBrandsUseCase = getAllBrandsUseCase
        self.getAllCategories = getAllCategories
    }
    
    func loadHomeData() async {
        isLoading = true
        errorMessage = nil

        do {
            self.products = try await getAllProductsUseCase.execute()
            self.brands = try await getAllBrandsUseCase.execute()
            let categories: [String] = try await getAllCategories.execute()
            self.categories = ["All"] + categories

            priceRange = 0...maxProductPrice
            
            // Note: featuredProducts is no longer built here — it's static
            // mock data set at declaration time above. Remove this comment
            // once real banner data is wired up from the backend.

            isLoading = false
        } catch {
            errorMessage = "Failed to load data \(error.localizedDescription)"
            isLoading = false
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
}
