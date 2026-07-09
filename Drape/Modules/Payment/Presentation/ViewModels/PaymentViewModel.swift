//
//  PaymentViewModel.swift
//  Drape
//

import Foundation

enum PaymentViewState: Equatable {
    case idle
    case loading
    case paymentReady(PaymentSession)
    case success(PaymentResult)
    case failure(String)
    case cancelled
}

@MainActor
@Observable
final class PaymentViewModel {
    var state: PaymentViewState = .idle

    private let startPaymentUseCase: StartPaymentUseCaseProtocol
    private let paymentRequest: PaymentRequest
    private let method: PaymentMethod

    init(
        paymentRequest: PaymentRequest,
        method: PaymentMethod = .paymob,
        startPaymentUseCase: StartPaymentUseCaseProtocol = StartPaymentUseCase(
            repository: PaymentRepository()
        )
    ) {
        self.paymentRequest = paymentRequest
        self.method = method
        self.startPaymentUseCase = startPaymentUseCase
    }

    func startPayment() async {
        guard state == .idle else { return }

        state = .loading

        do {
            let session = try await startPaymentUseCase.execute(method: method, request: paymentRequest)
            state = .paymentReady(session)
        } catch {
            state = .failure(error.localizedDescription)
        }
    }

    @discardableResult
    func handleRedirect(url: URL) -> Bool {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = components?.queryItems ?? []

        guard let successValue = queryItems.first(where: { $0.name == "success" })?.value else {
            return false
        }

        if successValue == "true" {
            let transactionId = queryItems.first(where: { $0.name == "id" })?.value
            state = .success(.success(transactionId: transactionId))
            return true
        }

        let pendingValue = queryItems.first(where: { $0.name == "pending" })?.value
        if pendingValue == "true" {
            state = .failure("Payment is pending. Please try again or choose another payment method.")
        } else {
            state = .failure("Payment failed. Please check your card details and try again.")
        }

        return true
    }

    func cancelPayment() {
        state = .cancelled
    }
}
