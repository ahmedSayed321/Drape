//
//  OrdersViewModel.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import Foundation

@MainActor
final class OrdersViewModel: ObservableObject {

    @Published var ongoingOrders: [OrderUIState] = []
    @Published var completedOrders: [OrderUIState] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let email: String
    private let orderListUseCase: OrderListUseCaseProtocol
    private let getProductDetailsUseCase: GetProductDetailsUseCase

    init(
        email: String = "",
        orderListUseCase: OrderListUseCaseProtocol,
        getProductDetailsUseCase: GetProductDetailsUseCase = GetProductDetailsUseCase()
    ) {
        self.email = email
        self.orderListUseCase = orderListUseCase
        self.getProductDetailsUseCase = getProductDetailsUseCase
    }

    func loadOrders() async {
        isLoading = true
        errorMessage = nil

        do {
            var orders = try await orderListUseCase.getOrders(email: email, status: .any)
            await enrichWithImages(&orders)

            ongoingOrders = orders
                .filter { $0.fulfillmentStatus != .fulfilled }
                .map { $0.toUIState() }
            completedOrders = orders
                .filter { $0.fulfillmentStatus == .fulfilled }
                .map { $0.toUIState() }

        } catch {
            errorMessage = "Failed to load orders: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func enrichWithImages(_ orders: inout [Order]) async {
        let uniqueProductIds = Set(orders.flatMap { $0.lineItems.map(\.productId) })

        var imagesByProductId: [Int: String] = [:]

        await withTaskGroup(of: (Int, String?).self) { group in
            for productId in uniqueProductIds {
                group.addTask {
                    let product = try? await self.getProductDetailsUseCase.execute(productId: productId)
                    return (productId, product?.mainImage)
                }
            }
            for await (productId, imageUrl) in group {
                if let imageUrl {
                    imagesByProductId[productId] = imageUrl
                }
            }
        }

        orders = orders.map { order in
            var order = order
            order.lineItems = order.lineItems.map { item in
                var item = item
                item.imageURL = imagesByProductId[item.productId]
                return item
            }
            return order
        }
    }
}
