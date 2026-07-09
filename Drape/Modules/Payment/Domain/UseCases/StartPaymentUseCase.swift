//
//  StartPaymentUseCase.swift
//  Drape
//

import Foundation

protocol StartPaymentUseCaseProtocol {
    func execute(method: PaymentMethod, request: PaymentRequest) async throws -> PaymentSession
}

final class StartPaymentUseCase: StartPaymentUseCaseProtocol {
    private let repository: PaymentRepositoryProtocol

    init(repository: PaymentRepositoryProtocol) {
        self.repository = repository
    }

    func execute(method: PaymentMethod, request: PaymentRequest) async throws -> PaymentSession {
        try await repository.startPayment(method: method, request: request)
    }
}
