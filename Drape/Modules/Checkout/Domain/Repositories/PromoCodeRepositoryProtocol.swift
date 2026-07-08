//
//  PromoCodeRepositoryProtocol.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

protocol PromoCodeRepositoryProtocol {
    func validate(code: String) async throws -> ValidatedPromoCode
}
