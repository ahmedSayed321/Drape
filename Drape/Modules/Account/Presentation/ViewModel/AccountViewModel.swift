//
//  AccountViewModel.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import Foundation
import FirebaseAuth

@MainActor
final class AccountViewModel: ObservableObject {
    @Published var isLoggingOut = false
    @Published var logoutError: String?

    private let logoutUseCase: LogoutUseCase

    init(logoutUseCase: LogoutUseCase = LogoutUseCase(repository: FirebaseAuthRepository())) {
        self.logoutUseCase = logoutUseCase
    }
    
    
    func logout() -> Bool {
        isLoggingOut = true
        logoutError = nil
        defer { isLoggingOut = false }

        do {
            try logoutUseCase.execute()
            return true
        } catch {
            logoutError = "Something went wrong while logging out. Please try again."
            return false
        }
    }
    
    func getEmailForUser() -> String {Auth.auth().currentUser?.email ?? ""}
}
