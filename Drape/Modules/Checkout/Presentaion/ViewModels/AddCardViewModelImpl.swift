import Foundation

struct AddCardViewModel {
    var state = AddCardUiState()

    mutating func updateCardNumber(_ value: String) {
        state.cardNumber = value
        state.cardNumberState = value.filter { $0.isNumber }.count >= 12 ? .success : .error
    }

    mutating func updateExpiryDate(_ value: String) {
        state.expiryDate = value
        // Simple MM/YY validation
        let parts = value.split(separator: "/")
        if parts.count == 2, let mm = Int(parts[0]), (1...12).contains(mm), parts[1].count == 2 {
            state.expiryDateState = .success
        } else {
            state.expiryDateState = .error
        }
    }

    mutating func updateSecurityCode(_ value: String) {
        state.securityCode = value
        state.securityCodeState = value.filter { $0.isNumber }.count >= 3 ? .success : .error
    }

    mutating func addCardTapped() {
        guard state.isAddEnabled else { return }
        state.isSaving = true

        // simulate work
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            var masked = state.cardNumber.filter { $0.isNumber }
            if masked.count > 4 {
                let last4 = masked.suffix(4)
                masked = String(repeating: "*", count: max(0, masked.count - 4)) + last4
            }
            let card = CardItem(id: UUID(), brand: detectBrand(from: state.cardNumber), maskedNumber: masked, isDefault: true)
            CheckoutStorage.shared.addCard(card)
            state.isSaving = false
            state.isSuccessVisible = true
        }
    }

    func makeCardItem() -> CardItem {
        let masked = state.cardNumber.filter { $0.isNumber }
        let visible = masked.count > 4 ? "**** **** **** \(masked.suffix(4))" : masked
        return CardItem(id: UUID(), brand: detectBrand(from: state.cardNumber), maskedNumber: visible, isDefault: state.isSuccessVisible)
    }

    mutating func dismissSuccess() {
        state.isSuccessVisible = false
        state.cardNumber = ""
        state.expiryDate = ""
        state.securityCode = ""
    }

    private func detectBrand(from number: String) -> String {
        let digits = number.filter { $0.isNumber }
        if digits.hasPrefix("4") { return "VISA" }
        if digits.hasPrefix("5") { return "Mastercard" }
        return "Card"
    }
}
