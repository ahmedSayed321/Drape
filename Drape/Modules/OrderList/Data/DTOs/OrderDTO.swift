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

extension OrderDTO {
    func toDomain() -> Order {
        Order(
            id: id ?? 0,
            name: name ?? "Unknown Order",
            financialStatus: financialStatus ?? "pending",
            fulfillmentStatus: FulfillmentStatus(rawValue: fulfillmentStatus),
            totalPrice: totalPrice ?? "0.00",
            currency: currency ?? "USD",
            lineItems: (lineItems ?? []).map { $0.toDomain() }
        )
    }
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

extension OrderLineItemDTO {
    func toDomain() -> OrderLineItem {
        OrderLineItem(
            id: id ?? 0,
            productId: productId ?? 0,
            title: title ?? "Unknown Product",
            variantTitle: variantTitle,
            price: price ?? "0.00",
            quantity: quantity ?? 1,
            vendor: vendor ?? "Unknown",
            imageURL: nil
        )
    }
}
