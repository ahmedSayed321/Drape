//
//  CartRepository .swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

protocol CartRepository {
    func createDraftOrder(items: [CartLineItem], customerId: String) async throws -> Cart
    func getDraftOrder(id: String) async throws -> Cart
    func updateLineItemQuantity(draftOrderId: String, variantId: String, quantity: Int) async throws -> Cart
    func removeLineItem(draftOrderId: String, variantId: String) async throws -> Cart
    func clearCart(draftOrderId: String) async throws
    func checkStock(variantId: String) async throws -> Int
    func replaceLineItems(draftOrderId: String, items: [CartLineItem]) async throws -> Cart
}
