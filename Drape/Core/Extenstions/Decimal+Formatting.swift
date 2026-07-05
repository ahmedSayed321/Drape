//
//  Decimal+Formatting.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import Foundation

extension Decimal {
    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}
