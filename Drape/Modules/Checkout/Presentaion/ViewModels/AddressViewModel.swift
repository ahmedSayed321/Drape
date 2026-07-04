//
//  AddressViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

@Observable
final class AddressViewModel {
     var addresses: [AddressItem] = [
        AddressItem(
            id: UUID(),
            title: "Home",
            details: "925 S Chugach St #APT 10, Alaska 99645",
            isDefault: true
        ),
        AddressItem(
            id: UUID(),
            title: "Office",
            details: "2438 6th Ave, Ketchikan, Alaska 99901",
            isDefault: false
        ),
        AddressItem(
            id: UUID(),
            title: "Apartment",
            details: "2551 Vista Dr #B301, Juneau, Alaska 99801",
            isDefault: false
        ),
        AddressItem(
            id: UUID(),
            title: "Parent’s House",
            details: "4821 Ridge Top Cir, Anchorage, Alaska 99501",
            isDefault: false
        )
    ]

    var selectedAddressID: UUID?

    init() {
        selectedAddressID = addresses.first(where: { $0.isDefault })?.id
    }

    var isApplyEnabled: Bool {
        selectedAddressID != nil
    }

    var selectedAddress: AddressItem? {
        addresses.first(where: { $0.id == selectedAddressID })
    }

    func selectAddress(_ address: AddressItem) {
        selectedAddressID = address.id
    }
}
