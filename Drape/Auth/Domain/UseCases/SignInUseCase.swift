//
//  SignInUseCase.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//

import Foundation

final class SignInUseCase {
    private let authRepository: AuthRepositoryProtocol
    private let customerRepository: CustomerRepositoryProtocol

    private let keychain: KeychainTokenStorage

    init(authRepository: AuthRepositoryProtocol, customerRepository: CustomerRepositoryProtocol, keychain: KeychainTokenStorage = KeychainTokenStorage()) {
        self.authRepository = authRepository
        self.customerRepository = customerRepository
        self.keychain = keychain
    }

    
    func execute(email: String, password: String) async throws -> String {
       
        _ = try await authRepository.signIn(email: email, password: password)

        guard let shopifyCustomerID = try await customerRepository.fetchShopifyCustomerID(email: email) else {
            throw SignInError.shopifyCustomerNotFound
        }

        if keychain.getCartDraftOrderID() == nil {
            if let serverDraftOrderId = try? await customerRepository.fetchDraftOrderId(customerId: shopifyCustomerID) {
                keychain.saveCartDraftOrderID(serverDraftOrderId)
            }
        }

        return shopifyCustomerID
    }
}
