//
//  Cart.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

struct Cart {
    let draftOrderId: String
    var lineItems: [CartLineItem]
    let subtotal: Decimal
    let tax: Decimal
    let shippingFee: Decimal = 80
    let total: Decimal
    let invoiceURL: URL?
}

struct CartLineItem: Identifiable {
    let id: String            // variantId, used for stepper/delete lookups
    let lineItemId: Int      // Shopify's own line item id, needed when updating/removing
    let title: String?
    let size: String?
    var imageURL: URL?
    let price: Decimal?
    var quantity: Int?
    var productId: Int?
}


extension Cart {
    func toUpdateRequestDTO() -> DraftOrderRequestBody {
        DraftOrderRequestBody(
            lineItems: lineItems.map { item in
                LineItemRequestDTO(
                    variantId: Int(item.id) ?? 0,
                    quantity: item.quantity
                )
            },
            customer: nil
        )
    }
}

extension CartLineItem {
    func toRequestDTO() -> LineItemRequestDTO {
        LineItemRequestDTO(
            variantId: Int(id) ?? 0,
            quantity: quantity
        )
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}
