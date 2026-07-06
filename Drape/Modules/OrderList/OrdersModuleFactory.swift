//
//  OrdersModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//


enum OrdersModuleFactory {
    @MainActor
    static func makeOrdersView(customerRepository: CustomerRepositoryProtocol) -> OrdersScreen {
        let remoteDataSource = OrdersRemoteDataSourceImpl()
        let ordersRepository = OrdersRepositoryImpl(remoteDataSource: remoteDataSource)

        let orderListUseCase = OrderListUseCase(
            ordersRepository: ordersRepository,
            customerRepository: customerRepository
        )

        let viewModel = OrdersViewModel(
            orderListUseCase: orderListUseCase
        )
        return OrdersScreen(viewModel: viewModel)
    }
}
