//
//  CartRemoteDataSource.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

protocol CartRemoteDataSourceProtocol {
    func createDraftOrder(_ body: CreateDraftOrderRequestDTO) async throws -> DraftOrderResponseDTO
    func getDraftOrder(id: String) async throws -> DraftOrderResponseDTO
    func updateDraftOrder(id: String, body: CreateDraftOrderRequestDTO) async throws -> DraftOrderResponseDTO
    func deleteDraftOrder(id: String) async throws
    func checkStock(inventoryItemId: String, locationId: String) async throws -> InventoryLevelResponseDTO
    func fetchProducts(ids: String) async throws -> ProductsResponse
}

final class CartRemoteDataSource: CartRemoteDataSourceProtocol {
    private let networkService: NetworkService

    init(networkService: NetworkService = NetworkService.shared) {
        self.networkService = networkService
    }

    func createDraftOrder(_ body: CreateDraftOrderRequestDTO) async throws -> DraftOrderResponseDTO {
        try await networkService.request(CartEndpoint.createDraftOrder(body: body))
    }

    func getDraftOrder(id: String) async throws -> DraftOrderResponseDTO {
        try await networkService.request(CartEndpoint.getDraftOrder(id: id))
    }

    func updateDraftOrder(id: String, body: CreateDraftOrderRequestDTO) async throws -> DraftOrderResponseDTO {
        try await networkService.request(CartEndpoint.updateDraftOrder(id: id, body: body))
    }

    func deleteDraftOrder(id: String) async throws {
        let _: EmptyResponseDTO = try await networkService.request(CartEndpoint.deleteDraftOrder(id: id))
    }

    func checkStock(inventoryItemId: String, locationId: String) async throws -> InventoryLevelResponseDTO {
        try await networkService.request(CartEndpoint.checkStock(inventoryItemId: inventoryItemId, locationId: locationId))
    }
    
    func fetchProducts(ids: String) async throws -> ProductsResponse {
        try await networkService.request(ProductsEndpoint(ids: ids))
    }
}
