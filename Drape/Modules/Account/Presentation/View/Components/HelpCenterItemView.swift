//
//  HelpCenterItemView.swift
//  Drape
//
//  Created by Moaz on 05/07/2026.
//

import SwiftUI

struct HelpCenterItemView: View {
    let item: HelpCenterItem
    
    private let color = Color(hex: "1A1A1A")
    private let borderColor = Color(hex: "E6E6E6")
    
    var body: some View {
        HStack() {
            iconView
                .frame(width: 24, height: 24)
            
            Text(item.title)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(color)
            
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.vertical,14)
        
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1.0)
                .fill(borderColor)
        }
    }
    
    @ViewBuilder
        private var iconView: some View {
            switch item.icon {
            case .system(let name):
                Image(systemName: name)
                    .font(.system(size: 20))
                    .foregroundStyle(Color(hex: "1A1A1A"))
            case .asset(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
            }
        }
}

#Preview {
    HelpCenterItemView(item: HelpCenterItem(
        icon: .system("headphones"),
        title: "Customer Service"
    ))
}
