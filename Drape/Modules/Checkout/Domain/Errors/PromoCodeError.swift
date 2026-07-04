//
//  PromoCodeError.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation

enum PromoCodeError: Error, Equatable {
    case invalidCode
    case expired
    case notYetActive
    case networkFailure

    var message: String {
        switch self {
        case .invalidCode:    return "This promo code isn't valid."
        case .expired:        return "This promo code has expired."
        case .notYetActive:   return "This promo code isn't active yet."
        case .networkFailure: return "Something went wrong. Please try again."
        }
    }
}
