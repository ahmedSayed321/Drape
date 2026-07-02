//
//  SignUpUseCase.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
import FirebaseAuth


final class SignUpUseCase {
    private let authRepository: AuthRepositoryProtocol
    private let customerRepository: CustomerRepositoryProtocol
    
    init(authRepository: AuthRepositoryProtocol, customerRepository: CustomerRepositoryProtocol) {
        self.authRepository = authRepository
        self.customerRepository = customerRepository
    }
    
    func execute(fullName: String, email: String, password: String) async throws -> AppUser {
        
        do {
            // 1. Firebase signup → saves UID + token to Keychain internally
            _ = try await authRepository.signUp(email: email, password: password)
        } catch SignUpError.emailAlreadyInUse {
            // Ignore
            print("Firebase user already exists")
        }catch {
            print("Error happen in Firebase")
            throw error
        }
            // 2. Create/find Shopify customer → reads UID from Keychain itself
        print("Trying to create shopify acc")
            return try await customerRepository.createShopifyCustomer(fullName: fullName, email: email)
        }
}
