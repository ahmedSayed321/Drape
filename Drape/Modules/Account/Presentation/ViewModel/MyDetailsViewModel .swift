//
//  MyDetailsViewModel.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import Foundation

@MainActor
final class MyDetailsViewModel: ObservableObject {

    @Published var fullName: String
    @Published var fullNameState: TextFieldState = .normal

    @Published var email: String
    @Published var emailState: TextFieldState = .normal

    @Published var isLoading = false
    @Published var dateOfBirth: Date

    @Published var gender: Gender

    @Published var selectedCountry: CountryCode
    @Published var phoneNumber: String

    @Published var isSubmitting = false
    @Published var submitError: String?

    @Published var showReauthPrompt = false
    @Published var reauthPassword = ""

    @Published var didSaveSuccessfully = false


    private let authRepository: FirebaseAuthRepository

    init(
        fullName: String = "",
        email: String = "",
        dateOfBirth: Date = Calendar.current.date(from: DateComponents(year: 1990, month: 7, day: 12)) ?? Date(),
        gender: Gender = .male,
        selectedCountry: CountryCode = CountryCode.all[0],
        phoneNumber: String = "",
        authRepository: FirebaseAuthRepository = FirebaseAuthRepository()
    ) {
        self.fullName = fullName
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.selectedCountry = selectedCountry
        self.phoneNumber = phoneNumber
        self.authRepository = authRepository
    }

    private func validateFullName() -> Bool {
        let trimmed = fullName.trimmingCharacters(in: .whitespaces)
        fullNameState = trimmed.isEmpty ? .error : .success
        return trimmed.isEmpty == false
    }

    private func validateEmail() -> Bool {
        let trimmed = email.trimmingCharacters(in: .whitespaces)
        let isValid = trimmed.contains("@") && trimmed.contains(".") && !trimmed.isEmpty
        emailState = isValid ? .success : .error
        return isValid
    }

    private func validateAll() -> Bool {
        let nameValid = validateFullName()
        let emailValid = validateEmail()
        return nameValid && emailValid
    }


    var formattedDateOfBirth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateOfBirth)
    }

    var fullPhoneNumber: String {
        "\(selectedCountry.dialCode)\(phoneNumber)"
    }


    func submit() async {
        guard validateAll() else { return }

        isSubmitting = true
        submitError = nil
        didSaveSuccessfully = false
        defer { isSubmitting = false }

        do {
            try await authRepository.updateProfile(fullName: fullName, email: email)

            let refreshed = try await authRepository.refreshedUserDetails()
            fullName = refreshed.fullName
            email = refreshed.email

            didSaveSuccessfully = true

        } catch ProfileUpdateError.requiresRecentLogin {
            showReauthPrompt = true
        } catch {
            submitError = (error as? LocalizedError)?.errorDescription
                ?? "Something went wrong. Please try again."
        }
    }

    func confirmReauthAndRetry() async {
        guard !reauthPassword.isEmpty else { return }

        isSubmitting = true
        submitError = nil
        defer { isSubmitting = false }

        do {
            try await authRepository.reauthenticate(email: email, password: reauthPassword)
            try await authRepository.updateProfile(fullName: fullName, email: email)

            let refreshed = try await authRepository.refreshedUserDetails()
            fullName = refreshed.fullName
            email = refreshed.email

            showReauthPrompt = false
            reauthPassword = ""
            didSaveSuccessfully = true
        } catch {
            submitError = (error as? LocalizedError)?.errorDescription
                ?? "Re-authentication failed. Please check your password."
        }
    }
    
    func loadCurrentUserDetails() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let current = try await authRepository.refreshedUserDetails()
            fullName = current.fullName
            email = current.email
        } catch {
            submitError = (error as? LocalizedError)?.errorDescription
                ?? "Couldn't load your details. Please try again."
        }
    }
}
