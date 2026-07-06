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

private extension OrderDTO {
    func toDomain() -> Order {
        Order(
            id: id ?? 0,
            name: name ?? "Unknown Order",
            financialStatus: financialStatus ?? "pending",
            fulfillmentStatus: FulfillmentStatus(rawValue: fulfillmentStatus),
            totalPrice: totalPrice ?? "0.00",
            currency: currency ?? "USD",
            lineItems: (lineItems ?? []).map { $0.toDomain() }
        )
    }
}

private extension OrderLineItemDTO {
    func toDomain() -> OrderLineItem {
        OrderLineItem(
            id: id ?? 0,
            productId: productId ?? 0,
            title: title ?? "Unknown Product",
            variantTitle: variantTitle,
            price: price ?? "0.00",
            quantity: quantity ?? 1,
            vendor: vendor ?? "Unknown",
            imageURL: nil
        )
    }
}
