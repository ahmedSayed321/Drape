//
//  LogoutUseCase.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//

import Foundation

struct LogoutUseCase {
    let repository: AuthRepositoryProtocol
    func execute() throws {
        try repository.signOut()
    }
}
