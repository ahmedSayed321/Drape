//
//  SignInError.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//

import Foundation

enum SignInError: LocalizedError {
    case accountNotFound
    case invalidEmail
    case userDisabled
    case shopifyCustomerNotFound
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .accountNotFound:
            return "Account not found. Please check your email and password and try again."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .userDisabled:
            return "This account has been disabled. Please contact support."
        case .shopifyCustomerNotFound:
            return "We couldn't find your store profile. Please contact support."
        case .unknown(let message):
            return message
        }
    }
}
