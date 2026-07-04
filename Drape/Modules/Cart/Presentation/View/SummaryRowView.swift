//
//  SummaryRowView.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//

import SwiftUI

struct SummaryRowView: View {
    let title: String
    let price: String
    var isEmphasized: Bool = false
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(isEmphasized ?  Color(hex: "1A1A1A") : Color(hex: "808080"))
            
            Spacer()
            
            Text("$ \(price)")
                .font(.system(size: 16, weight: isEmphasized ? .semibold : .medium))
                .foregroundStyle(Color(hex: "1A1A1A"))

        }
    }
}

#Preview {
    SummaryRowView(title: "Sub-total", price: "5,870")
}

