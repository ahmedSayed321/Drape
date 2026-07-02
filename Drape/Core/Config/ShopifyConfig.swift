//
//  ShopifyConfig.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import Foundation

enum ShopifyConfig {
    static let hostname = "https://mad46-ios-team8.myshopify.com"
    static let apiVersion = "2024-01"

    static var accessToken: String {
        Bundle.main.infoDictionary?["SHOPIFY_ACCESS_TOKEN"] as? String ?? ""
    }

    static var baseURL: String {
        "\(hostname)/admin/api/\(apiVersion)"
    }

    static var defaultHeaders: [String: String] {
        [
            "X-Shopify-Access-Token": accessToken,
            "Content-Type": "application/json"
        ]
    }
}
