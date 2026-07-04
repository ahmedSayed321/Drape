//
//  OrderResponse.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

struct ShopifyDraftOrderResponseDTO: Decodable {
    let draftOrder: ShopifyDraftOrderDTO
    
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
    
}

struct ShopifyDraftOrderDTO: Decodable {
    let id: Int
    let name: String
    let totalPrice: String
    let subtotalPrice: String
    let totalTax: String
    let appliedDiscount: AppliedDiscountDTO?
    let lineItems: [LineItemDTO]
    let orderId: Int?
    
    struct AppliedDiscountDTO: Decodable {
        let title: String
        let value: String
        let valueType: String
        let amount: String
    }
    
    struct LineItemDTO: Decodable {
        let id: Int
        let variantId: Int?
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
