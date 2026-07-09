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
    var clearFavoritesUseCase: ClearAllSavedProductsUseCaseProtocol?

    init(
        logoutUseCase: LogoutUseCase = LogoutUseCase(repository: FirebaseAuthRepository()),
        clearFavoritesUseCase: ClearAllSavedProductsUseCaseProtocol? = nil
    ) {
        self.logoutUseCase = logoutUseCase
        self.clearFavoritesUseCase = clearFavoritesUseCase
    }
    
    
    func logout() -> Bool {
        isLoggingOut = true
        logoutError = nil
        defer { isLoggingOut = false }

        do {
            try logoutUseCase.execute()
            try? clearFavoritesUseCase?.execute()
            return true
        } catch {
            logoutError = "Something went wrong while logging out. Please try again."
            return false
        }
    }
    
    func getEmailForUser() -> String {Auth.auth().currentUser?.email ?? ""}
}
