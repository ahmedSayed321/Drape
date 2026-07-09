//
//  PaymobDTOs.swift
//  Drape
//

import Foundation

struct PaymobAuthRequestDTO: Encodable {
    let apiKey: String
}

struct PaymobAuthResponseDTO: Decodable {
    let token: String
}

struct PaymobOrderRequestDTO: Encodable {
    let authToken: String
    let deliveryNeeded: String
    let amountCents: Int
    let currency: String
    let merchantOrderId: String?
    let items: [PaymobItemDTO]
}

struct PaymobItemDTO: Encodable {
    let name: String
    let amountCents: Int
    let description: String
    let quantity: Int
}

struct PaymobOrderResponseDTO: Decodable {
    let id: Int
}

struct PaymobPaymentKeyRequestDTO: Encodable {
    let authToken: String
    let amountCents: Int
    let expiration: Int
    let orderId: Int
    let billingData: PaymobBillingDataDTO
    let currency: String
    let integrationId: Int
    let lockOrderWhenPaid: Bool
}

struct PaymobBillingDataDTO: Encodable {
    let apartment: String
    let email: String
    let floor: String
    let firstName: String
    let street: String
    let building: String
    let phoneNumber: String
    let shippingMethod: String
    let postalCode: String
    let city: String
    let country: String
    let lastName: String
    let state: String
}

struct PaymobPaymentKeyResponseDTO: Decodable {
    let token: String
}

struct PaymobErrorResponseDTO: Decodable {
    let detail: String?
    let message: String?
    let error: String?
}
