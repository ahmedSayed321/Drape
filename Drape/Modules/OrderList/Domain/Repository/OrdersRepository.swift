//
//  OrdersRepository.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

protocol OrdersRepository {
    func getOrders(customerId: Int, status: OrderStatusFilter) async throws -> [Order]
}

enum OrderStatusFilter: String {
    case open
    case closed
    case any
}
