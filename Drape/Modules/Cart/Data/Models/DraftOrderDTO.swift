//
//  DraftOrderDTO.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

// Response DTOs
struct DraftOrderResponseDTO: Decodable {
    let draftOrder: DraftOrderDTO
 
}

struct DraftOrderDTO: Decodable {
    let id: Int
    let name: String?
    let lineItems: [DraftOrderLineItemDTO]?
    let subtotalPrice: String?
    let totalTax: String?
    let totalPrice: String?
    let currency: String?
    let invoiceUrl: String?
    let shippingLine: ShippingLineDTO?

}

struct DraftOrderLineItemDTO: Decodable {
    let id: Int?
    let productId: Int?
    let variantId: Int?
    let title: String?
    let variantTitle: String?
    let quantity: Int?
    let price: String?
    let sku: String?
    let properties: [LineItemPropertyResponseDTO]?
}

struct LineItemPropertyResponseDTO: Decodable {
    let name: String?
    let value: String?
}

struct ShippingLineDTO: Codable {
    let title: String?
    let price: String?
}

// Helper function : pull image URL out of properties

extension DraftOrderLineItemDTO {
    var imageURLString: String? {
        properties?.first(where: { $0.name == "_image_url" })?.value
    }
}

// Request DTOs (encoding, for POST/PUT)

struct CreateDraftOrderRequestDTO: Encodable {
    let draftOrder: DraftOrderRequestBody
}

struct DraftOrderRequestBody: Encodable {
    let lineItems: [LineItemRequestDTO]
    let customer: CustomerDTO?

}

struct CustomerDTO : Codable {
    let id: String
}

struct LineItemRequestDTO: Encodable {
    let variantId: Int?
    let quantity: Int?
}

struct LineItemPropertyDTO: Encodable {
    let name: String
    let value: String
}

