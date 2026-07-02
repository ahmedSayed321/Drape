//
//  ProductRepositoryImpl.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

final class SearchRepositoryImpl: SearchRepositoryProtocol {
    private let remoteDataSource: SearchRemoteDataSourceProtocol

    init(remoteDataSource: SearchRemoteDataSourceProtocol = SearchRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchAllProducts() async throws -> [Product] {
        let response = try await remoteDataSource.fetchAllProducts(limit: 50, sortOrder: "created_at desc")
        return response.products.map { $0.toDomain() }
    }
}

private extension ProductDTO {
    func toDomain() -> Product {
        Product(
            id: id,
            title: title,
            vendor: vendor,
            productType: productType,
            price: variants.first?.price ?? "0.00",
            compareAtPrice: variants.first?.compareAtPrice,
            imageURL: images.first?.src ?? ""
        )
    }
}
