//
//  TokenStorageProtocol.swift
//  Drape
//
//  Created by TaqieAllah on 30/06/2026.
//

import Foundation
protocol TokenStorageProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func clearToken()
    func saveFirebaseUID(_ uid: String)
    func getFirebaseUID() -> String?
    func clearAll()
}

