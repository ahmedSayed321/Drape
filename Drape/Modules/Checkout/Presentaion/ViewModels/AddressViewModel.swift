//
//  AddressViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

@MainActor
@Observable
final class AddressViewModel {
    var addresses: [AddressItem] = []
    var selectedAddressID: UUID?
    var errorMessage: String?

    var isApplyEnabled: Bool {
        selectedAddressID != nil
    }

    var selectedAddress: AddressItem? {
        addresses.first(where: { $0.id == selectedAddressID })
    }

    func selectAddress(_ address: AddressItem) {
        selectedAddressID = address.id
        addresses = addresses.map { addr in
            var updated = addr
            updated.isDefault = (addr.id == address.id)
            return updated
        }
        CheckoutStorage.shared.updateAddresses(addresses)
    }

    func deleteAddress(id: UUID) {
        CheckoutStorage.shared.deleteAddress(id: id)
        addresses.removeAll { $0.id == id }
        if selectedAddressID == id {
            selectedAddressID = addresses.first?.id
        }
    }

    func reload() {
        addresses = CheckoutStorage.shared.loadAddresses()
        if selectedAddressID == nil || !addresses.contains(where: { $0.id == selectedAddressID }) {
            selectedAddressID = addresses.first?.id
        }
    }
}
