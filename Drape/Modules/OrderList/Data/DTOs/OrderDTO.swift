//
//  OrderDTO.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

struct OrdersResponseDTO: Decodable {
    let orders: [OrderDTO]?
}

struct OrderDTO: Decodable {
    let id: Int?
    let name: String?
    let financialStatus: String?
    let fulfillmentStatus: String?
    let totalPrice: String?
    let currency: String?
    let lineItems: [OrderLineItemDTO]?
}

struct OrderLineItemDTO: Decodable {
    let id: Int?
    let productId: Int?
    let title: String?
    let variantTitle: String?
    let price: String?
    let quantity: Int?
    let vendor: String?
}
