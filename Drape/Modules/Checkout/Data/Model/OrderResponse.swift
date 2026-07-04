//
//  OrderResponse.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

struct ShopifyDraftOrderResponseDTO: Decodable {
    let draft_order: ShopifyDraftOrderDTO
}

struct ShopifyDraftOrderDTO: Decodable {
    let id: Int
    let name: String
    let total_price: String
    let subtotal_price: String
    let total_tax: String
    let applied_discount: AppliedDiscountDTO?
    let line_items: [LineItemDTO]
    let order_id: Int?   // populated once completed

    struct AppliedDiscountDTO: Decodable {
        let title: String
        let value: String
        let value_type: String
        let amount: String
    }

    struct LineItemDTO: Decodable {
        let id: Int
        let variant_id: Int?
        let title: String
        let quantity: Int
        let price: String
    }
}

struct ShopifyOrderResponseDTO: Decodable {
    let order: ShopifyOrderDTO
}

struct ShopifyOrderDTO: Decodable {
    let id: Int
    let name: String
    let total_price: String
    let financial_status: String
    let fulfillment_status: String?
}

struct ShopifyCustomerOrdersResponseDTO: Decodable {
    let orders: [ShopifyOrderDTO]
}
