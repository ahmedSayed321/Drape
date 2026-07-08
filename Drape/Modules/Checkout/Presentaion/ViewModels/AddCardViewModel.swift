//
//  AddCardViewModel.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class AddCardViewModel {
    var state = AddCardUiState()

    func updateCardNumber(_ value: String) {
        let digits = value.filter(\.isNumber)
        let limited = String(digits.prefix(16))
        state.cardNumber = formatCardNumber(limited)
        state.cardNumberState = limited.count == 16 ? .success : .normal
    }

    func updateExpiryDate(_ value: String) {
        let digits = value.filter(\.isNumber)
        let limited = String(digits.prefix(4))

        if limited.count >= 3 {
            let month = limited.prefix(2)
            let year = limited.suffix(limited.count - 2)
            state.expiryDate = "\(month)/\(year)"
        } else {
            state.expiryDate = limited
        }

        if limited.count < 4 {
            state.expiryDateState = .normal
        } else {
            state.expiryDateState = isExpiryDateValid(limited) ? .success : .error
        }
    }

    func updateSecurityCode(_ value: String) {
        let digits = value.filter(\.isNumber)
        let limited = String(digits.prefix(3))
        state.securityCode = limited
        state.securityCodeState = limited.count == 3 ? .success : .normal
    }

    func addCardTapped() {
        guard state.isAddEnabled else { return }
        state.isSaving = true

        state.isSaving = false
        state.isSuccessVisible = true
    }

    func dismissSuccess() {
        state.isSuccessVisible = false
    }

    func makeCardItem() -> CardItem {
        CardItem(
            id: UUID(),
            brand: detectBrand(from: state.cardNumberDigits),
            maskedNumber: maskedNumber(from: state.cardNumberDigits),
            isDefault: false
        )
    }

    private func formatCardNumber(_ digits: String) -> String {
        stride(from: 0, to: digits.count, by: 4).map { index in
            let start = digits.index(digits.startIndex, offsetBy: index)
            let end = digits.index(start, offsetBy: min(4, digits.count - index), limitedBy: digits.endIndex) ?? digits.endIndex
            return String(digits[start..<end])
        }.joined(separator: " ")
    }

    private func maskedNumber(from digits: String) -> String {
        let suffix = String(digits.suffix(4))
        return "**** **** **** \(suffix)"
    }

    private func detectBrand(from digits: String) -> String {
        if digits.hasPrefix("4") { return "VISA" }
        if digits.hasPrefix("5") { return "Mastercard" }
        return "Card"
    }

    /// Validates a 4-digit MMYY string: month must be 01-12, and the
    /// month/year combination must not be earlier than the current month.
    private func isExpiryDateValid(_ digits: String) -> Bool {
        guard digits.count == 4 else { return false }

        let monthString = String(digits.prefix(2))
        let yearSuffixString = String(digits.suffix(2))

        guard
            let month = Int(monthString),
            let yearSuffix = Int(yearSuffixString),
            month >= 1, month <= 12
        else {
            return false
        }

        let fullYear = 2000 + yearSuffix

        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        let currentMonth = calendar.component(.month, from: now)

        if fullYear != currentYear {
            return fullYear > currentYear
        }
        return month >= currentMonth
    }
}
