//
//  ShopifyOrderRequestDTO.swift
//  Drape
//
//  Created by TaqieAllah on 08/07/2026.
//

import Foundation
struct ShopifyOrderRequestDTO: Encodable {
    struct OrderBody: Encodable {
        let line_items: [LineItem]
        let customer: Customer
        let shipping_address: ShippingAddress?
        let discount_codes: [DiscountCode]?
        let financial_status: String
        let send_receipt: Bool
    }

    struct LineItem: Encodable {
        let variant_id: Int
        let quantity: Int
    }

    struct Customer: Encodable {
        let id: Int
    }

    struct ShippingAddress: Encodable {
        let first_name: String
        let last_name: String
        let address1: String
        let city: String
        let country: String
        let phone: String?
    }

    struct DiscountCode: Encodable {
        let code: String
        let amount: String
    }

    let order: OrderBody
}
