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

    init(authRepository: AuthRepositoryProtocol, customerRepository: CustomerRepositoryProtocol) {
        self.authRepository = authRepository
        self.customerRepository = customerRepository
    }

    
    func execute(email: String, password: String) async throws -> String {
       
        _ = try await authRepository.signIn(email: email, password: password)

        guard let shopifyCustomerID = try await customerRepository.fetchShopifyCustomerID(email: email) else {
            throw SignInError.shopifyCustomerNotFound
        }

        return shopifyCustomerID
    }
}
