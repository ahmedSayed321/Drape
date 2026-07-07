//
//  AuthRepositoryProtocol.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
protocol AuthRepositoryProtocol {
    func signUp(email: String, password: String) async throws -> String // returns ID token
    
    func signIn(email: String, password: String) async throws -> String // returns ID token
    func signOut() throws
    func updateProfile(fullName: String, email: String) async throws
    func reauthenticate(email: String, password: String) async throws
}
