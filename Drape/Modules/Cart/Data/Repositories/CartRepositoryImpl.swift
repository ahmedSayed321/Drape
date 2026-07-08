//
//  CartRepositoryImpl.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

final class CartRepositoryImpl: CartRepository {
    private let remoteDataSource: CartRemoteDataSourceProtocol

    init(remoteDataSource: CartRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func createDraftOrder(items: [CartLineItem] , customerId: String) async throws -> Cart {
        let requestBody = CreateDraftOrderRequestDTO(
            draftOrder: DraftOrderRequestBody(
                lineItems: items.map { $0.toRequestDTO() },
                customer: CustomerDTO(id: customerId)
            )
        )

        do {
            let response = try await remoteDataSource.createDraftOrder(requestBody)
            let cart = CartMapper.toDomain(response.draftOrder)
            return cart
        } catch {
            throw error
        }
    }

    func getDraftOrder(id: String) async throws -> Cart {
        let response = try await remoteDataSource.getDraftOrder(id: id)
        return CartMapper.toDomain(response.draftOrder)
    }

    func updateLineItemQuantity(draftOrderId: String, variantId: String, quantity: Int) async throws -> Cart {
        let current = try await getDraftOrder(id: draftOrderId)
        var updatedItems = current.lineItems
        guard let index = updatedItems.firstIndex(where: { $0.id == variantId }) else {
            throw CartError.lineItemNotFound
        }
        updatedItems[index].quantity = quantity

        let requestBody = CreateDraftOrderRequestDTO(
            draftOrder: DraftOrderRequestBody(
                lineItems: updatedItems.map { $0.toRequestDTO() },
                customer: nil
            )
        )
        let response = try await remoteDataSource.updateDraftOrder(id: draftOrderId, body: requestBody)
        return CartMapper.toDomain(response.draftOrder)
    }

    func replaceLineItems(draftOrderId: String, items: [CartLineItem]) async throws -> Cart {
        let requestBody = CreateDraftOrderRequestDTO(
            draftOrder: DraftOrderRequestBody(
                lineItems: items.map { $0.toRequestDTO() },
                customer: nil   
            )
        )
        let response = try await remoteDataSource.updateDraftOrder(id: draftOrderId, body: requestBody)
        return CartMapper.toDomain(response.draftOrder)
    }
    
    func removeLineItem(draftOrderId: String, variantId: String) async throws -> Cart {
        let current = try await getDraftOrder(id: draftOrderId)
        let remainingItems = current.lineItems.filter { $0.id != variantId }

        let requestBody = CreateDraftOrderRequestDTO(
            draftOrder: DraftOrderRequestBody(
                lineItems: remainingItems.map { $0.toRequestDTO() },
                customer: nil
            )
        )
        let response = try await remoteDataSource.updateDraftOrder(id: draftOrderId, body: requestBody)
        return CartMapper.toDomain(response.draftOrder)
    }

    func clearCart(draftOrderId: String) async throws {
        try await remoteDataSource.deleteDraftOrder(id: draftOrderId)
    }

    func checkStock(variantId: String) async throws -> Int {
        let response = try await remoteDataSource.checkStock(
            inventoryItemId: variantId,
            locationId: ShopifyConfig.defaultLocationId
        )
        return response.inventoryLevels?.first?.available ?? 0
    }
}

enum CartError: Error {
    case lineItemNotFound
}
