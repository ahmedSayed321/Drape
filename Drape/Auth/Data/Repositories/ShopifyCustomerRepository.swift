//
//  ShopifyCustomerRepository.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.

import Foundation

final class ShopifyCustomerRepository: CustomerRepositoryProtocol {

    private let dataSource: ShopifyAuthRemoteDataSource
    private let tokenStorage: KeychainTokenStorage

    init(
        dataSource: ShopifyAuthRemoteDataSource = ShopifyAuthRemoteDataSource(),
        tokenStorage: KeychainTokenStorage = KeychainTokenStorage()
    ) {
        self.dataSource = dataSource
        self.tokenStorage = tokenStorage
    }

    // Fetches existing Shopify customer ID by email — used during login
    func fetchShopifyCustomerID(email: String) async throws -> String? {
        let result = try await dataSource.searchCustomer(byEmail: email)
        guard let customer = result.customers.first else { return nil }
        let shopifyID = String(customer.id)
        tokenStorage.saveShopifyCustomerID(shopifyID)
        return shopifyID
    }

    // Creates or finds customer — used during signup
    func createShopifyCustomer(fullName: String, email: String) async throws -> AppUser {
        let result = try await dataSource.searchCustomer(byEmail: email)

        if let existing = result.customers.first {
            print("Customer already exists in Shopify")
            let shopifyID = String(existing.id)
            tokenStorage.saveShopifyCustomerID(shopifyID)
            return AppUser(
                id: tokenStorage.getFirebaseUID() ?? "",
                email: existing.email ?? email,
                fullName: [existing.first_name, existing.last_name]
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .joined(separator: " "),
                shopifyCustomerID: shopifyID,
                alreadyExisted: true
            )
        }

        return try await createCustomer(fullName: fullName, email: email)
    }

    private func createCustomer(fullName: String, email: String) async throws -> AppUser {
        let parts = fullName.trimmingCharacters(in: .whitespaces).components(separatedBy: " ")
        let firstName = parts.first ?? fullName
        let lastName = parts.dropFirst().joined(separator: " ")

        let firebaseUID = tokenStorage.getFirebaseUID() ?? ""
        let tags = firebaseUID.isEmpty ? "ios-app" : "ios-app, firebase:\(firebaseUID)"

        let body = ShopifyCreateCustomerRequestDTO(
            customer: .init(first_name: firstName, last_name: lastName, email: email, tags: tags)
        )

        let result = try await dataSource.createCustomer(body)
        let shopifyID = String(result.customer.id)
        tokenStorage.saveShopifyCustomerID(shopifyID)

        return AppUser(
            id: firebaseUID,
            email: result.customer.email ?? email,
            fullName: fullName,
            shopifyCustomerID: shopifyID,
            alreadyExisted: false
        )
    }
}
