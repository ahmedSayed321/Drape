//
//  CustomerAddressRepository.swift
//  Drape
//
//  Created by TaqieAllah on 06/07/2026.
//

import Foundation

protocol CustomerAddressRepositoryProtocol {
    func fetchAddresses(customerId: Int) async throws -> [RemoteCustomerAddress]
    func addAddress(customerId: Int, item: AddressItem, customerName: String, phone: String?) async throws -> RemoteCustomerAddress
    func deleteAddress(customerId: Int, addressId: Int) async throws
}

final class CustomerAddressRepository: CustomerAddressRepositoryProtocol {
    private let remoteDataSource: ShopifyCustomerAddressRemoteDataSourceProtocol

    init(remoteDataSource: ShopifyCustomerAddressRemoteDataSourceProtocol = ShopifyCustomerAddressRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchAddresses(customerId: Int) async throws -> [RemoteCustomerAddress] {
        let response = try await remoteDataSource.getAddresses(customerId: customerId)
        return response.addresses.map(map)
    }

    func addAddress(
        customerId: Int,
        item: AddressItem,
        customerName: String,
        phone: String?
    ) async throws -> RemoteCustomerAddress {

        let body = ShopifyCustomerAddressRequestDTO(
            address: item.toCustomerAddress(
                phone: phone
            )
        )

        let response = try await remoteDataSource.addAddress(
            customerId: customerId,
            body: body
        )

        return map(response.customerAddress)
    }
    func deleteAddress(customerId: Int, addressId: Int) async throws {
        try await remoteDataSource.deleteAddress(customerId: customerId, addressId: addressId)
    }

    private func map(_ dto: ShopifyCustomerAddressDTO) -> RemoteCustomerAddress {
        RemoteCustomerAddress(
            id: dto.id,
            name: dto.name,
            address1: dto.address1,
            city: dto.city,
            country: dto.country,
            phone: dto.phone
        )
    }
}
