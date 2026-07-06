//
//  OrdersRemoteDataSource.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//


protocol OrdersRemoteDataSource {
    func getCustomerOrders(customerId: Int, status: OrderStatusFilter) async throws -> [OrderDTO]
}

final class OrdersRemoteDataSourceImpl: OrdersRemoteDataSource {
    private let networkService: NetworkServiceProtocol   // matches your actual protocol name

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    func getCustomerOrders(customerId: Int, status: OrderStatusFilter) async throws -> [OrderDTO] {
        let endpoint = OrdersEndpoint.getCustomerOrders(customerId: customerId, status: status)
        let response: OrdersResponseDTO = try await networkService.request(endpoint)
        return response.orders ?? []
    }
}
