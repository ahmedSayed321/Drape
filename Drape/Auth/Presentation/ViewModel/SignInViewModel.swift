//
//  SignInViewModel.swift
//  Drape
//
//  Created by Me3bed on 01/07/2026.
//

import Foundation
import Observation
 
@Observable
final class SignInViewModel {
    var email = ""
    var password = ""
 
    var emailState: TextFieldState = .normal
    var passwordState: TextFieldState = .normal
 
    var emailError = "Please enter a valid email address"
    var passwordError = "Password must be at least 6 characters"
 
    var isLoading = false
 
    // Alert state — shown when the email/password don't match a Firebase
    // account (or any other sign in failure).
    var showAlert = false
    var alertMessage = ""
 
    var shopifyCustomerID: String?
 
    private let signInUseCase = SignInUseCase(
        authRepository: FirebaseAuthRepository(),
        customerRepository: ShopifyCustomerRepository()
    )
 
    var isFormValid: Bool {
        emailState == .success && passwordState == .success
    }
 
    func validateEmail() {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        if email.isEmpty {
            emailState = .normal
        } else if email.range(of: regex, options: .regularExpression) == nil {
            emailState = .error
            emailError = "Please enter a valid email address"
        } else {
            emailState = .success
        }
    }
 
    func validatePassword() {
        if password.isEmpty {
            passwordState = .normal
        } else if password.count < 6 {
            passwordState = .error
            passwordError = "Password must be at least 6 characters"
        } else {
            passwordState = .success
        }
    }
 
    func signIn() async {
        guard isFormValid else { return }
 
        isLoading = true
        defer { isLoading = false }
 
        do {
            
            let id = try await signInUseCase.execute(email: email, password: password)
            shopifyCustomerID = id
            // TODO: navigate to home now that sign-in succeeded
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
        }
    }
}
