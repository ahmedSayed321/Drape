//
//  SignInView.swift
//  Drape
//
//  Created by Me3bed on 27/06/2026.
//


import SwiftUI
 
struct SignInView: View {
 
    @State private var viewModel = SignInViewModel()
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            headerSection
            formSection
            createButton
            dividerSection
            socialButtons
            Spacer()
            goToSignUpSection
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 28)
        .alert("Account not found", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
 
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Login to your account")
                .font(.system(size: 32, weight: .bold))
 
            Text("It's great to see you again.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
    }
 
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
 
            VStack(alignment: .leading, spacing: 4) {
 
                CustomTextField(
                    title: "Email",
                    errorMessage: viewModel.emailError,
                    placeHolder: "Enter your email address",
                    textFieldValue: $viewModel.email,
                    state: $viewModel.emailState
                )
                .onChange(of: viewModel.email) { viewModel.validateEmail() }
                .padding(.bottom, 15)
 
                CustomTextField(
                    title: "Password",
                    isPassword: true,
                    errorMessage: viewModel.passwordError,
                    placeHolder: "Enter your password",
                    textFieldValue: $viewModel.password,
                    state: $viewModel.passwordState
                )
                .onChange(of: viewModel.password) { viewModel.validatePassword() }
                .padding(.bottom, 15)
            }
        }
    }
 
    private var createButton: some View {
 
        CustomButton(
            type: .primary,
            text: viewModel.isLoading ? "Logging in..." : "Login",
            action: {
                Task { await viewModel.signIn() }
            },
            status: (viewModel.isFormValid && !viewModel.isLoading) ? .enable : .disable
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
                type: .custom(
                    textColor: .black,
                    buttonColor: .white
                ),
                text: "Login with Google",
                action: {
                    
                },
                leading: Image("google")
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            }
            .padding(.bottom, 15)
 
            CustomButton(
                type: .custom(
                    textColor: .white,
                    buttonColor: .blue
                ),
                text: "Login with Facebook",
                action: {
 
                },
                leading: Image("facebook")
            )
            .padding(.bottom, 15)

            
            CustomButton(
                type: .custom(
                    textColor: .black,
                    buttonColor: .white
                ),
                text: "Guest",
                action: {
                    router.showHome()
                }
               
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            }
            
         
            
        }
    }
 
    private var goToSignUpSection: some View {
        HStack (spacing: 0){
 
 
            Text("Don't have an account? ")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            Button {
                router.showSignUp()
                   } label: {
                       Text("Join")
                           .font(.system(size: 14, weight: .semibold))
                           .foregroundColor(.black)
                           .underline()
                   }
                   .buttonStyle(.plain)
 
 
        }.frame(maxWidth: .infinity, alignment: .center)
 
    }
}
 
#Preview {
    SignInView()
}
