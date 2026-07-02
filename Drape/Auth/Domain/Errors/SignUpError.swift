//
//  SignUpError.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
enum SignUpError: LocalizedError {
    case emailAlreadyInUse
    case weakPassword
    case invalidEmail
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .emailAlreadyInUse: return "This email is already registered."
        case .weakPassword: return "Password is too weak."
        case .invalidEmail: return "Please enter a valid email address."
        case .unknown(let message): return message
        }
    }
}
