//
//  PaymobEndpoint.swift
//  Drape
//

import Foundation

enum PaymobEndpoint {
    case auth
    case createOrder
    case paymentKey

    var url: URL? {
        switch self {
        case .auth:
            return URL(string: "\(PaymobConfig.baseURL)/auth/tokens")
        case .createOrder:
            return URL(string: "\(PaymobConfig.baseURL)/ecommerce/orders")
        case .paymentKey:
            return URL(string: "\(PaymobConfig.baseURL)/acceptance/payment_keys")
        }
    }
}
