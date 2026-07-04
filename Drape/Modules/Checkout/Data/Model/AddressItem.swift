//
//  AddressItem.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation


struct AddressItem: Identifiable, Equatable, Hashable, Codable {
    let id: UUID
    var title: String
    var details: String
    var isDefault: Bool
    // Optional coordinates (stored when picked on map)
    var latitude: Double?
    var longitude: Double?

    // Provide CodingKeys to maintain compatibility
    enum CodingKeys: String, CodingKey {
        case id, title, details, isDefault, latitude, longitude
    }
}

extension AddressItem {
    func toShippingAddress(
        firstName: String,
        lastName: String,
        phone: String?,
        country: String = "Egypt"
    ) -> ShopifyDraftOrderRequestDTO.ShippingAddress {
        .init(
            first_name: firstName,
            last_name: lastName,
            address1: details,
            address2: nil,
            city: title,        // e.g. "Home", "Work" — not ideal but harmless placeholder
            province: nil,
            country: country,
            zip: "",
            phone: phone
        )
    }

    var locationNote: String? {
        guard let latitude, let longitude else { return nil }
        return "Location: \(latitude), \(longitude)"
    }
}
