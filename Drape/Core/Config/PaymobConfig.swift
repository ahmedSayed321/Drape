//
//  PaymobConfig.swift
//  Drape
//

import Foundation

enum PaymobConfig {
    static let baseURL = "https://accept.paymob.com/api"

    static var apiKey: String {
        Bundle.main.infoDictionary?["PAYMOB_API_KEY"] as? String ?? ""
    }

    static var integrationId: Int {
        Int(Bundle.main.infoDictionary?["PAYMOB_INTEGRATION_ID"] as? String ?? "") ?? 0
    }

    static var iframeId: Int {
        Int(Bundle.main.infoDictionary?["PAYMOB_IFRAME_ID"] as? String ?? "") ?? 0
    }

    static var isConfigured: Bool {
        !apiKey.isEmpty && integrationId > 0 && iframeId > 0
    }
}
