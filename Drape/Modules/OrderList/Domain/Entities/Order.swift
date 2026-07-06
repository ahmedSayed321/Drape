//
//  Order.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import Foundation


struct Order: Identifiable, Equatable {
    let id: Int
    let name: String                  // e.g. "#1015"
    let financialStatus: String       // "pending", "paid", "refunded", etc.
    let fulfillmentStatus: FulfillmentStatus
    let totalPrice: String
    let currency: String
    var lineItems: [OrderLineItem]
}

enum FulfillmentStatus: String, Equatable {
    case unfulfilled
    case partial
    case fulfilled

    init(rawValue: String?) {
        switch rawValue {
        case "fulfilled": self = .fulfilled
        case "partial": self = .partial
        default: self = .unfulfilled   // covers nil from Shopify
        }
    }
}

struct OrderLineItem: Identifiable, Equatable {
    let id: Int
    let productId: Int
    let title: String
    let variantTitle: String?         // e.g. "4 / white"
    let price: String
    let quantity: Int
    let vendor: String
    var imageURL: String?             // filled in later via product lookup, not from this endpoint
}
