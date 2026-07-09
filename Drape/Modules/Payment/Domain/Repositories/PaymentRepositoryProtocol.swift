//
//  PaymentRepositoryProtocol.swift
//  Drape
//

import Foundation

protocol PaymentRepositoryProtocol {
    func startPayment(method: PaymentMethod, request: PaymentRequest) async throws -> PaymentSession
}
