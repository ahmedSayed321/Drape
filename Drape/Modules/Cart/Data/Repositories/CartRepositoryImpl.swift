//
//  CartRepositoryImpl.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

final class CartRepositoryImpl: CartRepository {
    private let remoteDataSource: CartRemoteDataSourceProtocol
    private var imageCache: [String: URL] = [:]

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
            var cart = CartMapper.toDomain(response.draftOrder)
            cart = try await attachImages(to: cart)
            NotificationCenter.default.post(name: .cartUpdated, object: cart)
            return cart
        } catch {
            throw error
        }
    }

    func getDraftOrder(id: String) async throws -> Cart {
        let response = try await remoteDataSource.getDraftOrder(id: id)
        var cart = CartMapper.toDomain(response.draftOrder)
        cart = try await attachImages(to: cart)
        return cart
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
        var cart = CartMapper.toDomain(response.draftOrder)
        cart = try await attachImages(to: cart)
        NotificationCenter.default.post(name: .cartUpdated, object: cart)
        return cart
    }

    func replaceLineItems(draftOrderId: String, items: [CartLineItem]) async throws -> Cart {
        let requestBody = CreateDraftOrderRequestDTO(
            draftOrder: DraftOrderRequestBody(
                lineItems: items.map { $0.toRequestDTO() },
                customer: nil   
            )
        )
        let response = try await remoteDataSource.updateDraftOrder(id: draftOrderId, body: requestBody)
        var cart = CartMapper.toDomain(response.draftOrder)
        cart = try await attachImages(to: cart)
        NotificationCenter.default.post(name: .cartUpdated, object: cart)
        return cart
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
        var cart = CartMapper.toDomain(response.draftOrder)
        cart = try await attachImages(to: cart)
        NotificationCenter.default.post(name: .cartUpdated, object: cart)
        return cart
    }

    func clearCart(draftOrderId: String) async throws {
        try await remoteDataSource.deleteDraftOrder(id: draftOrderId)
        NotificationCenter.default.post(name: .cartUpdated, object: Cart(draftOrderId: draftOrderId, lineItems: [], subtotal: 0, tax: 0,total: 0, invoiceURL: nil))
    }

    func checkStock(variantId: String) async throws -> Int {
        let response = try await remoteDataSource.checkStock(
            inventoryItemId: variantId,
            locationId: ShopifyConfig.defaultLocationId
        )
        return response.inventoryLevels?.first?.available ?? 0
    }
    
    private func attachImages(to cart: Cart) async throws -> Cart {
        var mutableCart = cart
        let missingProductIds = mutableCart.lineItems.compactMap { $0.productId }.filter { imageCache[String($0)] == nil }
        
        if !missingProductIds.isEmpty {
            let uniqueIds = Array(Set(missingProductIds))
            let idsString = uniqueIds.map(String.init).joined(separator: ",")
            if let response = try? await remoteDataSource.fetchProducts(ids: idsString) {
                for product in response.products {
                    if let firstImage = product.image, let url = URL(string: firstImage.src) {
                        imageCache[String(product.id)] = url
                    }
                }
            }
        }
        
        for i in 0..<mutableCart.lineItems.count {
            if let pid = mutableCart.lineItems[i].productId, let cachedURL = imageCache[String(pid)] {
                mutableCart.lineItems[i].imageURL = cachedURL
            }
        }
        
        return mutableCart
    }
}

enum CartError: Error {
    case lineItemNotFound
}
