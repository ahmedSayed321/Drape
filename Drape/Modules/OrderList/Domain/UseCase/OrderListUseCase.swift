//
//  GetCustomerOrdersUseCaseProtocol.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import Foundation

protocol OrderListUseCaseProtocol {
    func getOrders(email: String, status: OrderStatusFilter) async throws -> [Order]
}

struct OrderListUseCase: OrderListUseCaseProtocol {
    private let ordersRepository: OrdersRepository
    private let customerRepository: CustomerRepositoryProtocol

    // TODO: remove fallback once real email/session lookup is reliable
    private let fallbackCustomerId = "9864522399930"

    init(
        ordersRepository: OrdersRepository,
        customerRepository: CustomerRepositoryProtocol
    ) {
        self.ordersRepository = ordersRepository
        self.customerRepository = customerRepository
    }

    func getOrders(email: String, status: OrderStatusFilter) async throws -> [Order] {
        let customerIdString = try await resolveCustomerId(email: email)

        guard let customerId = Int(customerIdString) else {
            throw NSError(
                domain: "OrderListUseCase",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid customer ID"]
            )
        }

        return try await ordersRepository.getOrders(customerId: customerId, status: status)
    }

    private func resolveCustomerId(email: String) async throws -> String {
        if let fetchedId = try await customerRepository.fetchShopifyCustomerID(email: email), !fetchedId.isEmpty {
            return fetchedId
        }
        return fallbackCustomerId
    }
}
