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
    var remoteId: Int?

    // Provide CodingKeys to maintain compatibility
    enum CodingKeys: String, CodingKey {
        case id, title, details, isDefault, latitude, longitude, remoteId
    }
}

extension AddressItem {

    func toCustomerAddress(
        phone: String?,
        country: String = "Egypt"
    ) -> ShopifyCustomerAddressRequestDTO.Address {

        .init(
            address1: details,
            city: title,
            country: country,
            phone: phone,
            zip: nil
        )
    }

    static func from(remote: RemoteCustomerAddress) -> AddressItem {
        AddressItem(
            id: UUID(),
            title: remote.city?.nilIfBlank ?? remote.name?.nilIfBlank ?? "Unnamed Address",
            details: remote.address1?.nilIfBlank ?? "No address details",
            isDefault: false,
            latitude: nil,
            longitude: nil,
            remoteId: remote.id
        )
    }

    
    var locationNote: String? {
        guard let latitude, let longitude else { return nil }
        return "Location: \(latitude), \(longitude)"
    }
}

private extension String {
    var nilIfBlank: String? {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
