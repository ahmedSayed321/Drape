//
//  ProductDetailsDTO.swift
//  Drape
//
//  Created by Me3bed on 04/07/2026.
//

import Foundation

// MARK: - Root Response
struct ProductDetailsResponse: Decodable {
    let product: ProductDetail?
}

// MARK: - Product Detail
struct ProductDetail: Decodable, Identifiable {
    let id: Int?
    let title: String?
    let bodyHtml: String?
    let vendor: String?
    let productType: String?
    let createdAt: String?
    let handle: String?
    let updatedAt: String?
    let publishedAt: String?
    let templateSuffix: String?
    let publishedScope: String?
    let tags: String?
    let status: String?
    let adminGraphqlApiId: String?
    let variants: [ProductVariant]?
    let options: [ProductOption]?
    let images: [ProductImage]?
    let image: ProductImage?

    enum CodingKeys: String, CodingKey {
        case id, title, vendor, handle, status, variants, options, images, image
        case tags 
        case bodyHtml
        case productType = "product_type"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case templateSuffix = "template_suffix"
        case publishedScope = "published_scope"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

// MARK: - Product Variant
struct ProductVariant: Codable, Identifiable {
    let id: Int?
    let productId: Int?
    let title: String?
    let price: String?
    let position: Int?
    let inventoryPolicy: String?
    let compareAtPrice: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let createdAt: String?
    let updatedAt: String?
    let taxable: Bool?
    let barcode: String?
    let fulfillmentService: String?
    let grams: Int?
    let inventoryManagement: String?
    let requiresShipping: Bool?
    let sku: String?
    let weight: Double?
    let weightUnit: String?
    let inventoryItemId: Int?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let adminGraphqlApiId: String?
    let imageId: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, price, position, option1, option2, option3, taxable, barcode, grams, sku, weight
        case productId = "product_id"
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case requiresShipping = "requires_shipping"
        case weightUnit = "weight_unit"
        case inventoryItemId = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case imageId = "image_id"
    }
}

// MARK: - Product Option
struct ProductOption: Codable, Identifiable {
    let id: Int?
    let productId: Int?
    let name: String?
    let position: Int?
    let values: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, position, values
        case productId = "product_id"
    }
}

// MARK: - Product Image
struct ProductImage: Codable, Identifiable {
    let id: Int?
    let alt: String?
    let position: Int?
    let productId: Int?
    let createdAt: String?
    let updatedAt: String?
    let adminGraphqlApiId: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variantIds: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, alt, position, width, height, src
        case productId = "product_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case variantIds = "variant_ids"
    }
}


extension ProductDetail {

    func toEntity() -> ProductDetailsEntity {

        let sizes =
            options?
                .first(where: {
                    $0.name?.lowercased() == "size"
                })?
                .values ?? []

        let imageURLs =
            images?
                .compactMap { $0.src }
            ?? []

        let price = Double(variants?.first?.price ?? "") ?? 0

        return ProductDetailsEntity(
            title: title ?? "",
            description: bodyHtml ?? "No Description found yet.",
            vendor: vendor ?? "",
            productType: productType ?? "",
            sizes: sizes,
            mainImage: image?.src,
            imageURLs: imageURLs,
            price: price
        )
    }
}
