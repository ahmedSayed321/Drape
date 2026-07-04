//
//  KeychainTokenStorage.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
final class KeychainTokenStorage: TokenStorageProtocol {
    private let keychain = KeychainStorage()
    private let tokenKey = "firebase_id_token"
    private let firebaseUIDKey = "firebase_uid"
    private let shopifyCustomerIDKey = "shopify_customer_id"
    
    func saveToken(_ token: String) {
        try? keychain.save(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        keychain.read(forKey: tokenKey)
    }
    
    func clearToken() {
        try? keychain.delete(forKey: tokenKey)
    }
    
    func saveFirebaseUID(_ uid: String) {
        try? keychain.save(uid, forKey: firebaseUIDKey)
    }
    
    func getFirebaseUID() -> String? {
        keychain.read(forKey: firebaseUIDKey)
    }
    
    func saveShopifyCustomerID(_ id: String) {
        try? keychain.save(id, forKey: shopifyCustomerIDKey)
    }
    func getShopifyCustomerID() -> String? {
        keychain.read(forKey: shopifyCustomerIDKey)
    }
    func clearShopifyCustomerID() {
        try? keychain.delete(forKey: shopifyCustomerIDKey)
    }
    
    func clearAll() {
        try? keychain.delete(forKey: tokenKey)
        try? keychain.delete(forKey: firebaseUIDKey)
        try? keychain.delete(forKey: shopifyCustomerIDKey)
    }
    
}

