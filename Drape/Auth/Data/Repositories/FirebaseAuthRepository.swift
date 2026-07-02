//
//  FirebaseAuthRepository.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthRepository: AuthRepositoryProtocol {
    private let tokenStorage = KeychainTokenStorage()
    
    func signUp(email: String, password: String) async throws -> String {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let idToken = try await result.user.getIDToken()
            
            // Save both ID token and Firebase UID for later use
            tokenStorage.saveToken(idToken)
            tokenStorage.saveFirebaseUID(result.user.uid)
            
            return idToken
        } catch let error as NSError {
            if let code = AuthErrorCode(rawValue: error.code) {
                switch code {
                case .emailAlreadyInUse: throw SignUpError.emailAlreadyInUse
                case .weakPassword: throw SignUpError.weakPassword
                case .invalidEmail: throw SignUpError.invalidEmail
                default: throw SignUpError.unknown(error.localizedDescription)
                }
            }
            throw error
        }
    }
    
    func signIn(email: String, password: String) async throws -> String {
           do {
               let result = try await Auth.auth().signIn(withEmail: email, password: password)
               let idToken = try await result.user.getIDToken()
    
               tokenStorage.saveToken(idToken)
               tokenStorage.saveFirebaseUID(result.user.uid)
    
               return idToken
           } catch let error as NSError {
               if let code = AuthErrorCode(rawValue: error.code) {
                   switch code {
                   case .userNotFound, .wrongPassword, .invalidCredential:
                       throw SignInError.accountNotFound
                   case .invalidEmail:
                       throw SignInError.invalidEmail
                   case .userDisabled:
                       throw SignInError.userDisabled
                   default:
                       throw SignInError.unknown(error.localizedDescription)
                   }
               }
               throw error
           }
       }
}
