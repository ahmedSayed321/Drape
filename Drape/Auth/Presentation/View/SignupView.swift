//
//  SignupView.swift
//  Drape
//
//  Created by TaqieAllah on 27/06/2026.
//

import SwiftUI

struct SignupView: View {
    @State private var viewModel = SignupViewModel()
    @Environment(AppRouter.self) private var router

    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            formSection
            termsSection
            createButton
            dividerSection
            socialButtons
            loginSection
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
    }
       
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create an account")
                .font(.system(size: 32, weight: .bold))
            
            Text("Let’s create your account.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            CustomTextField(
                title: "Full Name",
                errorMessage: viewModel.fullNameError,
                placeHolder: "Enter your full name",
                textFieldValue: $viewModel.fullName,
                state: $viewModel.fullNameState
            )
            .onChange(of: viewModel.fullName) { viewModel.validateFullName()}

            CustomTextField(
                title: "Email",
                errorMessage: viewModel.emailError,
                placeHolder: "Enter your email address",
                textFieldValue: $viewModel.email,
                state: $viewModel.emailState
            )
            .onChange(of: viewModel.email) { viewModel.validateEmail() }

            CustomTextField(
                title: "Password",
                isPassword: true,
                errorMessage: viewModel.passwordError,
                placeHolder: "Enter your password",
                textFieldValue: $viewModel.password,
                state: $viewModel.passwordState
            )
            .onChange(of: viewModel.password) { viewModel.validatePassword() }

        }
    }
    
    private var termsSection: some View {
        Text("By signing up you agree to our Terms, Privacy Policy, and Cookie Use")
            .font(.system(size: 13))
            .foregroundColor(.gray)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    private var createButton: some View {
        return CustomButton(
            type: .primary,
            text: "Create an Account",
            action: {
                Task{ await viewModel.signUp()}
            },
            status: viewModel.isFormValid ? .enable : .disable
        )
    }
    
    private var dividerSection: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 1)
            
            Text("Or")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Rectangle()
                .fill(Color.gray.opacity(0.25))
                .frame(height: 1)
        }
    }
    
    private var socialButtons: some View {
        VStack(spacing: 14) {
            CustomButton(
                type: .custom(textColor: .black, buttonColor: .white),
                text: "Sign Up with Google",
                action: {
                    viewModel.signUpWithGoogle()
                },
                status: .enable,
                leading: Image("google")
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            
            CustomButton(
                type: .custom(textColor: .white, buttonColor: .blue),
                text: "Sign Up with Facebook",
                action: {
                    viewModel.signUpWithFacebook()
                },
                status: .enable,
                leading: Image("facebook")
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
        }
    }
    
    private var loginSection: some View {
        HStack(spacing: 4) {
            Text("Already have an account? ")
                .foregroundColor(.gray)
            
            Button(action: {
                router.showSignIn()
            }) {
                Text("Log In")
                    .foregroundColor(.black)
                    .underline()
            }
        }
        .font(.system(size: 15))
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
    }
}

#Preview {
    SignupView()
}
