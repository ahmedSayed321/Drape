//
//  PaymentSession.swift
//  Drape
//

import Foundation

struct PaymentSession: Equatable {
    let method: PaymentMethod
    let orderId: Int
    let paymentToken: String
    let paymentURL: URL
}
