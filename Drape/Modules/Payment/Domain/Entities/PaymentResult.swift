//
//  PaymentResult.swift
//  Drape
//

import Foundation

enum PaymentResult: Equatable {
    case success(transactionId: String?)
    case failure(message: String)
    case cancelled
}
