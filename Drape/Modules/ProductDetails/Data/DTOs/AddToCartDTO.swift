//
//  DraftOrderDTO.swift
//  Drape
//
//  Created by Me3bed on 06/07/2026.
//

import Foundation

struct DraftOrderRequest: Codable {
    let draftOrder: DraftOrder

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrder: Codable {
    let lineItems: [LineItem]
    let customer: Customer

    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customer
    }
}

struct LineItem: Codable {
    let variantId: String
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case variantId = "variant_id"
        case quantity
    }
}

struct Customer: Codable {
    let id: String
}
