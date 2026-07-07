//
//  OrdersScreen.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//


import SwiftUI

struct OrdersScreen: View {
    @StateObject var viewModel: OrdersViewModel
    @State private var selectedTab: Tab = .ongoing

    enum Tab {
        case ongoing, completed
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            Picker("", selection: $selectedTab) {
                Text("Ongoing").tag(Tab.ongoing)
                Text("Completed").tag(Tab.completed)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "wifi.exclamationmark",
                    description: Text(errorMessage)
                )
                Spacer()
            } else if currentOrders.isEmpty {
                EmptyOrdersView(tab: selectedTab)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 16) {
                        ForEach(currentOrders) { order in
                            OrderCard(order: order)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .background(Color.white.ignoresSafeArea())
        .task {
            await viewModel.loadOrders()
        }
    }

    private var currentOrders: [OrderUIState] {
        selectedTab == .ongoing ? viewModel.ongoingOrders : viewModel.completedOrders
    }

    private var header: some View {
        HStack {
            Spacer()
            Text("My Orders")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            Spacer()
        }
        .overlay(alignment: .trailing) {
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            .padding(.trailing)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 20)
    }
}

#Preview {
    OrdersModuleFactory.makeOrdersView(customerRepository: ShopifyCustomerRepository())
}
