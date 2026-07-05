//
//  CartEndpoint.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

enum CartEndpoint {
    case createDraftOrder(body: CreateDraftOrderRequestDTO)
    case getDraftOrder(id: String)
    case updateDraftOrder(id: String, body: CreateDraftOrderRequestDTO)
    case deleteDraftOrder(id: String)
    case checkStock(inventoryItemId: String, locationId: String)
}

extension CartEndpoint: APIEndpoint {
    var baseURL: String {
        ShopifyConfig.baseURL
    }

    var path: String {
        switch self {
        case .createDraftOrder:
            return "/draft_orders.json"
        case .getDraftOrder(let id), .updateDraftOrder(let id, _), .deleteDraftOrder(let id):
            return "/draft_orders/\(id).json"
        case .checkStock:
            return "/inventory_levels.json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createDraftOrder:
            return .post
        case .getDraftOrder, .checkStock:
            return .get
        case .updateDraftOrder:
            return .put
        case .deleteDraftOrder:
            return .delete
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .checkStock(let inventoryItemId, let locationId):
            return [
                "inventory_item_ids": inventoryItemId,
                "location_ids": locationId
            ]
        default:
            return nil
        }
    }

    var body: Encodable? {
        switch self {
        case .createDraftOrder(let body), .updateDraftOrder(_, let body):
            return body
        default:
            return nil
        }
    }
}
