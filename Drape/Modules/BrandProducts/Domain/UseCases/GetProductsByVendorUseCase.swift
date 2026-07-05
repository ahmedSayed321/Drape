//
//  GetProductsByVendorUseCaseProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 04/07/2026.
//


// Domain/UseCases/GetProductsByVendorUseCase.swift
protocol GetProductsByVendorUseCaseProtocol {
    func execute(vendor: String, limit: Int) async throws -> [Product]
}

struct GetProductsByVendorUseCase: GetProductsByVendorUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol = HomeRepositoryImpl()) {
        self.repository = repository
    }

    func execute(vendor: String, limit: Int) async throws -> [Product] {
        try await repository.fetchProducts(vendor: vendor, limit: limit)
    }
}
