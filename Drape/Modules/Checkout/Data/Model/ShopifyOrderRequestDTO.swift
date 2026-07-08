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

    let order: OrderBody
}
