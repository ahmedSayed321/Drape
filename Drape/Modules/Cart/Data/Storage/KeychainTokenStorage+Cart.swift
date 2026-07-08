//
//  KeychainTokenStorage+Cart.swift
//  Drape
//
//  Created by Moaz on 07/07/2026.
//

import Foundation

extension KeychainTokenStorage {
    private var cartDraftOrderKey: String { "cart_draft_order_id" }

    func getCartDraftOrderID() -> String? {
        keychain.read(forKey: cartDraftOrderKey)
    }

    func saveCartDraftOrderID(_ id: String) {
        try? keychain.save(id, forKey: cartDraftOrderKey)
    }

    func clearCartDraftOrderID() {
        try? keychain.delete(forKey: cartDraftOrderKey)
    }
}
