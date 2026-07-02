//
//  Signup_ViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 29/06/2026.
//

import Foundation
import Observation

@Observable
final class SignupViewModel {
    var fullName = ""
    var email = ""
    var password = ""
    
    var fullNameState: TextFieldState = .normal
    var emailState: TextFieldState = .normal
    var passwordState: TextFieldState = .normal
    
    var fullNameError = "Please enter your full name"
    var emailError = "Please enter a valid email address"
    var passwordError = "Password must be at least 8 characters"
    
    var isLoading = false
    var signUpError: String?
    var signedUpUser: AppUser?
    
    private let signUpUseCase = SignUpUseCase(
        authRepository: FirebaseAuthRepository(),
        customerRepository: ShopifyCustomerRepository()
    )
    
    var isFormValid: Bool {
        fullNameState == .success && emailState == .success && passwordState == .success
    }
    
    func validateFullName() {
        let trimmed = fullName.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            fullNameState = .error
            fullNameError = "Please enter your full name"
        } else if trimmed.count < 2 {
            fullNameState = .error
            fullNameError = "Name must be at least 2 characters"
        } else {
            fullNameState = .success
        }
    }
    
    func validateEmail() {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        if email.isEmpty {
            emailState = .error
            emailError = "Please enter your email address"
        } else if email.range(of: regex, options: .regularExpression) == nil {
            emailState = .error
            emailError = "Please enter a valid email address"
        } else {
            emailState = .success
        }
    }
    
    func validatePassword() {
        if password.isEmpty {
            passwordState = .error
            passwordError = "Please enter a password"
        } else if password.count < 8 {
            passwordState = .error
            passwordError = "Password must be at least 8 characters"
        } else {
            passwordState = .success
        }
    }
    
    func signUp() async {
        print("Started craeting")
        guard isFormValid else { return }
        
        isLoading = true
        signUpError = nil
        defer { isLoading = false }
        
        do {
            let user = try await signUpUseCase.execute(fullName: fullName, email: email, password: password)
            signedUpUser = user
            print("Signup succeeded for user: \(user)")
            // TODO: navigate to next screen now that signup succeeded
        } catch {
            signUpError = error.localizedDescription
            print(signUpError)
            print("this is my error : \(signUpError)")
        }
    }
    
    func signUpWithGoogle() {
        
    }
    
    func signUpWithFacebook() {
        
    }

    
}
