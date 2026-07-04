//
//  CheckoutStorage.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation
import os

final class CheckoutStorage {
    static let shared = CheckoutStorage()

    private let logger = Logger(subsystem: "Drape.Checkout", category: "CheckoutStorage")

    private let addressesFilename = "checkout_addresses.json"
    private let cardsFilename = "checkout_cards.json"

    private init() {}

    private func fileURL(for name: String) -> URL? {
        do {
            let fm = FileManager.default
            let appSupport = try fm.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dir = appSupport.appendingPathComponent("Drape", isDirectory: true)
            if !fm.fileExists(atPath: dir.path) {
                try fm.createDirectory(at: dir, withIntermediateDirectories: true)
            }
            return dir.appendingPathComponent(name)
        } catch {
            logger.error("failed to get file url: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Addresses
    func loadAddresses() -> [AddressItem] {
        guard let url = fileURL(for: addressesFilename) else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode([AddressItem].self, from: data)
            return items
        } catch {
            logger.debug("loadAddresses: no data or decode failed: \(error.localizedDescription)")
            return []
        }
    }

    func saveAddresses(_ addresses: [AddressItem]) {
        guard let url = fileURL(for: addressesFilename) else { return }
        do {
            let data = try JSONEncoder().encode(addresses)
            try data.write(to: url, options: [.atomic])
        } catch {
            logger.error("saveAddresses failed: \(error.localizedDescription)")
        }
    }

    func addAddress(_ address: AddressItem) {
        var current = loadAddresses()
        // If new address is default, clear others
        if address.isDefault {
            current = current.map { AddressItem(id: $0.id, title: $0.title, details: $0.details, isDefault: false, latitude: $0.latitude, longitude: $0.longitude) }
        }
        current.append(address)
        saveAddresses(current)
    }

    func deleteAddress(id: UUID) {
        var current = loadAddresses()
        current.removeAll { $0.id == id }
        saveAddresses(current)
    }

    func updateAddresses(_ addresses: [AddressItem]) {
        saveAddresses(addresses)
    }

    // MARK: - Cards
    func loadCards() -> [CardItem] {
        guard let url = fileURL(for: cardsFilename) else { return [] }
        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode([CardItem].self, from: data)
            return items
        } catch {
            logger.debug("loadCards: no data or decode failed: \(error.localizedDescription)")
            return []
        }
    }

    func saveCards(_ cards: [CardItem]) {
        guard let url = fileURL(for: cardsFilename) else { return }
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: url, options: [.atomic])
        } catch {
            logger.error("saveCards failed: \(error.localizedDescription)")
        }
    }

    func addCard(_ card: CardItem) {
        var current = loadCards()
        if card.isDefault {
            current = current.map { CardItem(id: $0.id, brand: $0.brand, maskedNumber: $0.maskedNumber, isDefault: false) }
        }
        current.append(card)
        saveCards(current)
    }

    func deleteCard(id: UUID) {
        var current = loadCards()
        current.removeAll { $0.id == id }
        saveCards(current)
    }
}
