//
//  OrdersRepositoryImpl.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//


final class OrdersRepositoryImpl: OrdersRepository {
    private let remoteDataSource: OrdersRemoteDataSource

    init(remoteDataSource: OrdersRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func getOrders(customerId: Int, status: OrderStatusFilter) async throws -> [Order] {
        let dtos = try await remoteDataSource.getCustomerOrders(customerId: customerId, status: status)
        return dtos.map { $0.toDomain() }
    }
}
