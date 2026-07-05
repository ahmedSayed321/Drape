//
//  MetafieldDTO.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

struct MetafieldResponseDTO: Decodable {
    let metafield: MetafieldDTO?
}

struct MetafieldDTO: Decodable {
    let id: Int?
    let namespace: String?
    let key: String?
    let value: String?       // JSON-encoded string, e.g. "[\"variantId1\",\"variantId2\"]"
    let type: String?       // "json" or "list.single_line_text_field"
}

struct UpdateMetafieldRequestDTO: Encodable {
    let metafield: MetafieldRequestBody?
}

struct MetafieldRequestBody: Encodable {
    let namespace: String?
    let key: String?
    let value: String?
    let type: String?
}
