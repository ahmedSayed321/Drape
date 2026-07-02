//
//  APIConfig.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 01/07/2026.
//

import Foundation

struct APIConfig {
    /// Safely extracts values from the app's Info.plist dictionary
    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("❌ Missing key '\(key)' in Info.plist configuration.")
        }
        return value
    }
    
    // These keys must match the exact string name you typed in the "Key" column of your Info.plist
    static var shopifyApiKey: String {
        return value(for: "ShopifyApiKey")
    }
    
    static var shopifyShopName: String {
        return value(for: "ShopifyShopName")
    }
}
