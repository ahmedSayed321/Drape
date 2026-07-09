//
//  PaymentModuleFactory.swift
//  Drape
//

import Foundation

enum PaymentModuleFactory {
    static func makePaymentView(
        paymentRequest: PaymentRequest,
        method: PaymentMethod = .paymob,
        onCompletion: @escaping (PaymentResult) -> Void
    ) -> PaymentView {
        PaymentView(paymentRequest: paymentRequest, method: method, onCompletion: onCompletion)
    }
}
