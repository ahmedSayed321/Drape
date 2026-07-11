//
//  GoogleSignInUseCase.swift
//  Drape
//
//  Created by Antigravity on 11/07/2026.
//

import Foundation

final class GoogleSignInUseCase {
    private let authRepository: AuthRepositoryProtocol
    private let customerRepository: CustomerRepositoryProtocol
    private let keychain: KeychainTokenStorage

    init(
        authRepository: AuthRepositoryProtocol,
        customerRepository: CustomerRepositoryProtocol,
        keychain: KeychainTokenStorage = KeychainTokenStorage()
    ) {
        self.authRepository = authRepository
        self.customerRepository = customerRepository
        self.keychain = keychain
    }
    
    @MainActor
    func execute() async throws -> String {
        // 1. Sign in with Google
        let googleUser = try await authRepository.signInWithGoogle()
        
        let shopifyCustomerID: String
        
        // 2. Check if a Shopify customer already exists for this email
        if let existingId = try await customerRepository.fetchShopifyCustomerID(email: googleUser.email) {
            shopifyCustomerID = existingId
        } else {
            // 3. Create a new Shopify customer if none exists
            let newCustomer = try await customerRepository.createShopifyCustomer(fullName: googleUser.fullName, email: googleUser.email)
            shopifyCustomerID = newCustomer.shopifyCustomerID
        }
        
        // 4. Draft order handling
        if keychain.getCartDraftOrderID() == nil {
            if let serverDraftOrderId = try? await customerRepository.fetchDraftOrderId(customerId: shopifyCustomerID) {
                keychain.saveCartDraftOrderID(serverDraftOrderId)
            }
        }
        
        return shopifyCustomerID
    }
}
