//
//  OrdersEndpoint.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//


enum OrdersEndpoint: APIEndpoint {
    case getCustomerOrders(customerId: Int, status: OrderStatusFilter)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .getCustomerOrders(let customerId, _):
            return "/customers/\(customerId)/orders.json"
        }
    }

    var method: HTTPMethod { .get }

    var headers: [String: String] { ShopifyConfig.defaultHeaders }

    var queryParameters: [String: String]? {
        switch self {
        case .getCustomerOrders(_, let status):
            return ["status": status.rawValue]
        }
    }
}
