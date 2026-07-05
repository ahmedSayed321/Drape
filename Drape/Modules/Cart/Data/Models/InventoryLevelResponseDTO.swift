//
//  InventoryLevelResponseDTO.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

struct InventoryLevelResponseDTO: Decodable {
    let inventoryLevels: [InventoryLevelDTO]?

    enum CodingKeys: String, CodingKey {
        case inventoryLevels = "inventory_levels"
    }
}

struct InventoryLevelDTO: Decodable {
    let available: Int
}
