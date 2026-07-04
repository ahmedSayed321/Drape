//
//  AddressViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

@Observable
final class AddressViewModel {
     var addresses: [AddressItem] = []

    var selectedAddressID: UUID?

    init() {
        // Load persisted addresses; if none exist create sensible defaults
        let stored = CheckoutStorage.shared.loadAddresses()
        if stored.isEmpty {
            addresses = [
                AddressItem(id: UUID(), title: "Home", details: "925 S Chugach St #APT 10, Alaska 99645", isDefault: true, latitude: nil, longitude: nil),
                AddressItem(id: UUID(), title: "Office", details: "2438 6th Ave, Ketchikan, Alaska 99901", isDefault: false, latitude: nil, longitude: nil)
            ]
            CheckoutStorage.shared.updateAddresses(addresses)
        } else {
            addresses = stored
        }

        selectedAddressID = addresses.first(where: { $0.isDefault })?.id
    }

    var isApplyEnabled: Bool {
        selectedAddressID != nil
    }

    var selectedAddress: AddressItem? {
        addresses.first(where: { $0.id == selectedAddressID })
    }

    func selectAddress(_ address: AddressItem) {
        // mark selection and persist default
        selectedAddressID = address.id
        addresses = addresses.map { addr in
            AddressItem(id: addr.id, title: addr.title, details: addr.details, isDefault: addr.id == address.id, latitude: addr.latitude, longitude: addr.longitude)
        }
        CheckoutStorage.shared.updateAddresses(addresses)
    }

    func addAddress(_ address: AddressItem) {
        // If new address is default, clear old defaults
        if address.isDefault {
            addresses = addresses.map { addr in
                AddressItem(id: addr.id, title: addr.title, details: addr.details, isDefault: false, latitude: addr.latitude, longitude: addr.longitude)
            }
        }
        addresses.append(address)
        CheckoutStorage.shared.saveAddresses(addresses)
    }

    func deleteAddress(id: UUID) {
        addresses.removeAll { $0.id == id }
        CheckoutStorage.shared.saveAddresses(addresses)
        if selectedAddressID == id {
            selectedAddressID = addresses.first?.id
        }
    }
    
    func reload() {
        addresses = CheckoutStorage.shared.loadAddresses()

        if selectedAddressID == nil || !addresses.contains(where: { $0.id == selectedAddressID }) {
            selectedAddressID = addresses.first(where: { $0.isDefault })?.id ?? addresses.first?.id
        }
    }
}
