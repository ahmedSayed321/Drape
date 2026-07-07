//
//  CustomerAddressesUseCase.swift
//  Drape
//
//  Created by TaqieAllah on 06/07/2026.
//

import Foundation

protocol FetchCustomerAddressesUseCaseProtocol {
    func getAddress(customerId: Int) async throws -> [RemoteCustomerAddress]
}

protocol DeleteCustomerAddressUseCaseProtocol {
    func deleteAddress(customerId: Int, addressId: Int) async throws
}

protocol AddCustomerAddressUseCaseProtocol {
    func addAddress(customerId: Int, item: AddressItem, customerName: String, phone: String?) async throws -> RemoteCustomerAddress
}



struct FetchCustomerAddressesUseCase: FetchCustomerAddressesUseCaseProtocol {
    let repository: CustomerAddressRepositoryProtocol
    func getAddress(customerId: Int) async throws -> [RemoteCustomerAddress] {
        try await repository.fetchAddresses(customerId: customerId)
    }
}



struct AddCustomerAddressUseCase: AddCustomerAddressUseCaseProtocol {
    let repository: CustomerAddressRepositoryProtocol
    func addAddress(customerId: Int, item: AddressItem, customerName: String, phone: String?) async throws -> RemoteCustomerAddress {
        try await repository.addAddress(customerId: customerId, item: item, customerName: customerName, phone: phone)
    }
}


struct DeleteCustomerAddressUseCase: DeleteCustomerAddressUseCaseProtocol {
    let repository: CustomerAddressRepositoryProtocol
    func deleteAddress(customerId: Int, addressId: Int) async throws {
        try await repository.deleteAddress(customerId: customerId, addressId: addressId)
    }
}
