//
//  OrderSummaryView.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import SwiftUI

struct OrderSummaryView: View {
    let subtotal: String
    let shipping: String
    let vat: String
    let total: String
    
    init(
        subtotal: String = "0",
        shipping: String = "80",
        vat: String = "0",
        total: String = "0"
    ) {
        self.subtotal = subtotal
        self.shipping = shipping
        self.vat = vat
        self.total = total
    }
    
    var body: some View {
        VStack(spacing: 16) {
            SummaryRowView(title: "Sub-total", price: subtotal)
            
            SummaryRowView(title: "VAT (%)", price: vat)
            
            SummaryRowView(title: "Shipping fee", price: shipping)
            
            Divider()
            
            SummaryRowView(title: "Total", price: total, isEmphasized: true)
        }
    }
}

#Preview {
    OrderSummaryView(
        subtotal: "5,870",
        shipping: "80",
        vat: "200",
        total: "5,950"
    )
}
