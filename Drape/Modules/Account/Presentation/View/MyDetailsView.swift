//
//  MyDetailsView.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import SwiftUI
import FirebaseAuth

struct MyDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: MyDetailsViewModel

    init() {
        let user = Auth.auth().currentUser
        _viewModel = StateObject(
            wrappedValue: MyDetailsViewModel(
                fullName: user?.displayName ?? "",
                email: user?.email ?? "",
                phoneNumber: user?.phoneNumber ?? ""
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                CustomTextField(
                    title: "Full Name",
                    placeHolder: "Enter your full name",
                    textFieldValue: $viewModel.fullName,
                    state: $viewModel.fullNameState
                )
                CustomTextField(
                    title: "Email Address",
                    placeHolder: "Enter your email",
                    textFieldValue: $viewModel.email,
                    state: $viewModel.emailState
                )
                DateOfBirthField(title: "Date of Birth", date: $viewModel.dateOfBirth)
                GenderPickerField(title: "Gender", selectedGender: $viewModel.gender)
                PhoneNumberField(
                    title: "Phone Number",
                    selectedCountry: $viewModel.selectedCountry,
                    phoneNumber: $viewModel.phoneNumber
                )
                if let submitError = viewModel.submitError {
                    Text(submitError)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }
                if viewModel.didSaveSuccessfully {
                    Text("Your details were saved.")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.green)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .safeAreaInset(edge: .bottom) {
            CustomButton(
                type: .primary,
                text: viewModel.isSubmitting ? "Submitting..." : "Submit"
            ) {
                Task { await viewModel.submit() }
            }
            .disabled(viewModel.isSubmitting)
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
            .background(Color.white)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("My Details")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
        .sheet(isPresented: $viewModel.showReauthPrompt) {
            VStack(spacing: 20) {
                Text("Confirm Your Password")
                    .font(.system(size: 18, weight: .semibold))

                Text("Changing your email requires you to confirm your current password.")
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)

                SecureField("Password", text: $viewModel.reauthPassword)
                    .padding(.horizontal, 12)
                    .frame(height: 52)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )

                if let submitError = viewModel.submitError {
                    Text(submitError)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.red)
                }

                CustomButton(
                    type: .primary,
                    text: viewModel.isSubmitting ? "Confirming..." : "Confirm"
                ) {
                    Task { await viewModel.confirmReauthAndRetry() }
                }
                .disabled(viewModel.isSubmitting)
            }
            .padding(24)
            .presentationDetents([.height(320)])
        }
        .task {
            await viewModel.loadCurrentUserDetails()
        }
    }
}

#Preview {
    MyDetailsView()
}
