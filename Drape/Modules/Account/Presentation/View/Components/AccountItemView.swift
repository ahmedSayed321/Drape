//
//  AccountItemView.swift
//  Drape
//
//  Created by Moaz on 05/07/2026.
//

import SwiftUI

struct AccountItemView: View {
    let icon: String
    let title: String
    var isLogOut = false
    var onTap: () -> Void
    

    private var leadingIcon: String {
        isLogOut ? "rectangle.portrait.and.arrow.right" : icon
    }
    
    private var color: Color {
        isLogOut ? Color(hex: "ED1010") : Color(hex: "1A1A1A")
    }
    
    var body: some View {
        Button(action: onTap, label: {
            HStack(alignment: .center) {
                Image(systemName: leadingIcon)
                    .font(.system(size: 24))
                    .padding(.trailing, 16)
                    .foregroundStyle(color)
                
                Text(title)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(color)
                
                Spacer()
                
                if !isLogOut  {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24))
                        .foregroundStyle(Color(hex: "B3B3B3"))
                }
            }
            .padding(.vertical, 24)
        })
    }
}

#Preview {
    AccountItemView(icon: "swift", title: "My Orders" ,
                    isLogOut: true, onTap: {})
}
