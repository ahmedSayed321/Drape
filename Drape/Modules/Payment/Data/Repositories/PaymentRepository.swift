//
//  PaymentRepository.swift
//  Drape
//

import Foundation

enum PaymentError: Error, LocalizedError, Equatable {
    case invalidConfiguration
    case unsupportedMethod
    case invalidPaymentURL
    case gateway(message: String, statusCode: Int)
    case network(String)
    case decoding

    var errorDescription: String? {
        switch self {
        case .invalidConfiguration:
            return "Payment gateway is not configured. Please add your Paymob keys."
        case .unsupportedMethod:
            return "This payment method is not available yet."
        case .invalidPaymentURL:
            return "Unable to open the payment page."
        case .gateway(let message, _):
            return message
        case .network(let message):
            return message
        case .decoding:
            return "Unable to read the payment gateway response."
        }
    }
}

final class PaymentRepository: PaymentRepositoryProtocol {
    private let remoteDataSource: PaymobRemoteDataSourceProtocol

    init(remoteDataSource: PaymobRemoteDataSourceProtocol = PaymobRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func startPayment(method: PaymentMethod, request: PaymentRequest) async throws -> PaymentSession {
        switch method {
        case .paymob:
            return try await startPaymobPayment(request)
        case .applePay:
            throw PaymentError.unsupportedMethod
        }
    }

    private func startPaymobPayment(_ request: PaymentRequest) async throws -> PaymentSession {
        guard PaymobConfig.isConfigured else {
            throw PaymentError.invalidConfiguration
        }

        let auth = try await remoteDataSource.authenticate()

        let order = try await remoteDataSource.createOrder(
            PaymobOrderRequestDTO(
                authToken: auth.token,
                deliveryNeeded: "false",
                amountCents: request.amountCents,
                currency: request.currency,
                merchantOrderId: request.merchantOrderId,
                items: request.items.map {
                    PaymobItemDTO(
                        name: $0.name,
                        amountCents: $0.amountCents,
                        description: $0.description,
                        quantity: $0.quantity
                    )
                }
            )
        )

        let paymentKey = try await remoteDataSource.createPaymentKey(
            PaymobPaymentKeyRequestDTO(
                authToken: auth.token,
                amountCents: request.amountCents,
                expiration: 3600,
                orderId: order.id,
                billingData: PaymobBillingDataDTO(
                    apartment: request.billingData.apartment,
                    email: request.billingData.email,
                    floor: request.billingData.floor,
                    firstName: request.billingData.firstName,
                    street: request.billingData.street,
                    building: request.billingData.building,
                    phoneNumber: request.billingData.phoneNumber,
                    shippingMethod: "NA",
                    postalCode: "NA",
                    city: request.billingData.city,
                    country: request.billingData.country,
                    lastName: request.billingData.lastName,
                    state: request.billingData.state
                ),
                currency: request.currency,
                integrationId: PaymobConfig.integrationId,
                lockOrderWhenPaid: true
            )
        )

        guard let paymentURL = URL(string: "\(PaymobConfig.baseURL)/acceptance/iframes/\(PaymobConfig.iframeId)?payment_token=\(paymentKey.token)") else {
            throw PaymentError.invalidPaymentURL
        }

        return PaymentSession(
            method: .paymob,
            orderId: order.id,
            paymentToken: paymentKey.token,
            paymentURL: paymentURL
        )
    }
}
