//
//  OrderRequest.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

struct ShopifyDraftOrderRequestDTO: Encodable {
    struct DraftOrderBody: Encodable {
        let line_items: [LineItem]
        let shipping_address: ShippingAddress?
        let applied_discount: AppliedDiscount?
        let email: String?
        let note: String?
    }

    struct LineItem: Encodable {
        let variant_id: Int
        let quantity: Int
    }

    struct ShippingAddress: Encodable {
        let first_name: String
        let last_name: String
        let address1: String
        let address2: String?
        let city: String
        let province: String?
        let country: String
        let zip: String
        let phone: String?
    }

    struct AppliedDiscount: Encodable {
        let description: String   // e.g. "Promo code SUMMER15"
        let value: String         // "15.0" — magnitude, not sign
        let value_type: String    // "percentage" or "fixed_amount"
        let title: String         // the code itself, shown on the order
    }

    let draft_order: DraftOrderBody
}
