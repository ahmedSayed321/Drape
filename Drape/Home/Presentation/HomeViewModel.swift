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
    
    var filteredProducts: [Product] {
        if selectedCategory == "All" {
            return products
        } else {
            return products.filter { $0.productType == selectedCategory }
        }
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
            
            isLoading = false
        } catch {
            errorMessage = "Failed to load data \(error.localizedDescription)"
            isLoading = false
        }
    }
}
