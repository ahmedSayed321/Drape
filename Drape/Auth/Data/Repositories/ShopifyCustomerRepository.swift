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

        if result.customers.first != nil {
            throw SignUpError.emailAlreadyInUse
        }
        print("Trying to create shopify acc in repo")
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
    
    func fetchDraftOrderId(customerId: String) async throws -> String? {
        let result = try await dataSource.fetchMetafields(customerId: customerId)
        let metafield = result.metafields.first { $0.namespace == "cart" && $0.key == "draft_order_id" }
        return metafield?.value
    }
    
    func updateDraftOrderId(customerId: String, draftOrderId: String) async throws {
        let requestBody = UpdateMetafieldRequestDTO(
            metafield: MetafieldRequestBody(
                namespace: "cart",
                key: "draft_order_id",
                value: draftOrderId,
                type: "single_line_text_field"
            )
        )
        _ = try await dataSource.updateMetafield(customerId: customerId, body: requestBody)
    }
}
