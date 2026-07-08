//
//  CustomerAddressEndpoint.swift
//  Drape
//
//  Created by TaqieAllah on 06/07/2026.
//

import Foundation

enum ShopifyCustomerAddressEndpoint: APIEndpoint {
    case getAddresses(customerId: Int)
    case addAddress(customerId: Int, body: ShopifyCustomerAddressRequestDTO)
    case deleteAddress(customerId: Int, addressId: Int)

    var baseURL: String { ShopifyConfig.baseURL }

    var path: String {
        switch self {
        case .getAddresses(let customerId), .addAddress(let customerId, _):
            return "/customers/\(customerId)/addresses.json"
        case .deleteAddress(let customerId, let addressId):
            return "/customers/\(customerId)/addresses/\(addressId).json"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getAddresses: return .get
        case .addAddress: return .post
        case .deleteAddress: return .delete
        }
    }

    var queryParameters: [String: String]? { nil }

    var body: Encodable? {
        switch self {
        case .addAddress(_, let body):
            return body
        default:
            return nil
        }
    }
}
