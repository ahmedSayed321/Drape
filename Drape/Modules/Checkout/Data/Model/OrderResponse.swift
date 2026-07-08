//
//  OrderResponse.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

struct ShopifyDraftOrderResponseDTO: Decodable {
    let draftOrder: ShopifyDraftOrderDTO
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
    let totalPrice: String
    let financialStatus: String
    let fulfillmentStatus: String?
}

struct ShopifyCustomerOrdersResponseDTO: Decodable {
    let orders: [ShopifyOrderDTO]
}
