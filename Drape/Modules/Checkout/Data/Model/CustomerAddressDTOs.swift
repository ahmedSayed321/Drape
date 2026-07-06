//
//  CustomerAddressDTOs.swift
//  Drape
//
//  Created by TaqieAllah on 06/07/2026.
//

import Foundation

struct ShopifyCustomerAddressRequestDTO: Encodable {

    let address: Address

    struct Address: Encodable {
        let address1: String
        let city: String
        let country: String
        let phone: String?
        let zip: String?
    }
}

struct ShopifyCustomerAddressListResponseDTO: Decodable {
    let addresses: [ShopifyCustomerAddressDTO]
}
struct ShopifyCustomerAddressResponseDTO: Decodable {
    let customerAddress: ShopifyCustomerAddressDTO
}

struct ShopifyCustomerAddressDTO: Decodable {
    let id: Int?
    let customerId: Int?
    let company: String?
    let province: String?
    let country: String?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    let isDefault: Bool?
    let address1: String?
    let address2: String?
    let city: String?
    let name: String?
    let phone: String?
    let zip: String?

    enum CodingKeys: String, CodingKey {
        case id, company, province, country, phone, zip, name, address1, address2, city
        case customerId = "customer_id"
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case isDefault = "default"
    }
}

struct RemoteCustomerAddress {
    let id: Int?
    let name: String?
    let address1: String?
    let city: String?
    let country: String?
    let phone: String?
}
