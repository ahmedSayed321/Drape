//
//  OrdersModuleFactory.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//


enum OrdersModuleFactory {
    @MainActor
    static func makeOrdersView(customerEmail: String) -> OrdersScreen {
        let remoteDataSource = OrdersRemoteDataSourceImpl()
        let ordersRepository = OrdersRepositoryImpl(remoteDataSource: remoteDataSource)
        let customerRepository = ShopifyCustomerRepository()

        let orderListUseCase = OrderListUseCase(
            ordersRepository: ordersRepository,
            customerRepository: customerRepository
        )

        let viewModel = OrdersViewModel(email: customerEmail,
            orderListUseCase: orderListUseCase
        )
        return OrdersScreen(viewModel: viewModel)
    }
}
