//
//  FirebaseAuthRepository.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import UIKit

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

    func updateProfile(fullName: String, email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw ProfileUpdateError.noCurrentUser
        }
 
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = fullName
        do {
            try await changeRequest.commitChanges()
        } catch let error as NSError {
            throw ProfileUpdateError.unknown(error.localizedDescription)
        }
 
        guard email != user.email else { return }
 
        // Using `updateEmail(to:)` (not `sendEmailVerification(beforeUpdatingEmail:)`)
        // so the change is IMMEDIATE: as soon as this call succeeds, the old
        // email address can no longer be used to sign in — only the new one.
        // No "click the link to confirm" step, no window where both work.
        // Note: newer Firebase SDKs surface a deprecation warning here and
        // steer you toward the verify-first flow for extra security, but
        // `updateEmail(to:)` is still fully functional and is the right call
        // for an immediate, no-verification email swap.
        do {
            try await user.updateEmail(to: email)
        } catch let error as NSError {
            if let code = AuthErrorCode(rawValue: error.code) {
                switch code {
                case .requiresRecentLogin:
                    throw ProfileUpdateError.requiresRecentLogin
                case .invalidEmail:
                    throw ProfileUpdateError.invalidEmail
                case .emailAlreadyInUse:
                    throw ProfileUpdateError.emailAlreadyInUse
                default:
                    throw ProfileUpdateError.unknown(error.localizedDescription)
                }
            }
            throw error
        }
    }

    /// Reloads the current user from Firebase and returns the freshly
    /// persisted `displayName` / `email`, so the caller (the view model) can
    /// reflect exactly what's now stored server-side rather than assuming
    /// the local, pre-submit values are still accurate.
    func refreshedUserDetails() async throws -> (fullName: String, email: String) {
        guard let user = Auth.auth().currentUser else {
            throw ProfileUpdateError.noCurrentUser
        }
        try await user.reload()
        return (user.displayName ?? "", user.email ?? "")
    }
 
    func reauthenticate(email: String, password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw ProfileUpdateError.noCurrentUser
        }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        do {
            try await user.reauthenticate(with: credential)
        } catch let error as NSError {
            throw ProfileUpdateError.unknown(error.localizedDescription)
        }
    }
 
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            tokenStorage.clearAll()
        } catch let error as NSError {
            throw SignOutError.unknown(error.localizedDescription)
        }
    }
    
    @MainActor
    func signInWithGoogle() async throws -> (email: String, fullName: String) {
        // 1. Get Root View Controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            throw SignInError.unknown("Could not find root view controller")
        }
        
        // 2. Start Google Sign In
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = result.user
        
        guard let idToken = user.idToken?.tokenString else {
            throw SignInError.unknown("No ID token found from Google")
        }
        let accessToken = user.accessToken.tokenString
        
        // 3. Authenticate with Firebase
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        
        // 4. Save tokens
        let firebaseIdToken = try await authResult.user.getIDToken()
        tokenStorage.saveToken(firebaseIdToken)
        tokenStorage.saveFirebaseUID(authResult.user.uid)
        
        let email = authResult.user.email ?? user.profile?.email ?? ""
        let fullName = authResult.user.displayName ?? user.profile?.name ?? "Google User"
        
        return (email: email, fullName: fullName)
    }
}
 
enum ProfileUpdateError: Error, LocalizedError {
    case noCurrentUser
    case requiresRecentLogin
    case invalidEmail
    case emailAlreadyInUse
    case unknown(String)
 
    var errorDescription: String? {
        switch self {
        case .noCurrentUser:
            return "No signed-in user found."
        case .requiresRecentLogin:
            return "Please re-enter your password to confirm this change."
        case .invalidEmail:
            return "That email address doesn't look valid."
        case .emailAlreadyInUse:
            return "That email is already in use by another account."
        case .unknown(let message):
            return message
        }
    }
}
 
enum SignOutError: Error, LocalizedError {
    case unknown(String)
 
    var errorDescription: String? {
        switch self {
        case .unknown(let message):
            return message
        }
    }
}
