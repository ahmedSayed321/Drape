//
//  VariantDTO.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

struct VariantDTO: Decodable {
    let id: Int
    let price: String
    let compareAtPrice: String?
    let option1: String?
    let option2: String?

    enum CodingKeys: String, CodingKey {
        case id, price
        case compareAtPrice = "compare_at_price"
        case option1, option2
    }
}
