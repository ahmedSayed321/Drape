//
//  ShopifyCheckoutEndpoint.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

enum ShopifyCheckoutEndpoint: APIEndpoint {
    case getDraftOrder(id: Int)
    case completeDraftOrder(id: Int, paymentPending: Bool)
    case getOrder(id: Int)
    case getCustomerOrders(customerId: Int)
    case createOrder(body: ShopifyOrderRequestDTO)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .getDraftOrder(let id):
            return "/draft_orders/\(id).json"
        case .completeDraftOrder(let id, _):
            return "/draft_orders/\(id)/complete.json"
        case .getOrder(let id):
            return "/orders/\(id).json"
        case .getCustomerOrders(let customerId):
            return "/customers/\(customerId)/orders.json"
        case .createOrder:
            return "/orders.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case  .completeDraftOrder, .createOrder: return .post
        case .getDraftOrder, .getOrder, .getCustomerOrders: return .get
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .completeDraftOrder(_, let pending):
            return ["payment_pending": pending ? "true" : "false"]
        default:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case .createOrder(let body):
            return body
        default:
            return nil
        }
    }
}
