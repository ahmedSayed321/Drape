//
//  CustomButton.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 27/06/2026.
//

import SwiftUI

enum ButtonType {
    case primary
    case custom (textColor: Color, buttonColor: Color)
}

enum ButtonStatus {
    case enable
    case disable
}

struct CustomButton: View {
    
    // CustomButton(type:.primary, text:"tap me", actoin: sayHello(), status: .enable)
    
    // the type is .primary or .custom
    // the status is .enable or .disable
    // if custom then you should take background color and foreground color
    
    // Required
    let type: ButtonType
    let text: String
    let action: () -> Void
    var status: ButtonStatus = .enable
    
    // Optional
    var leading: Image?
    var trailing: Image?
    
    var backgroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                    .black
            case .custom(_, let buttonColor):
                buttonColor
            }
        } else {
            .gray
        }
    }
    var foregroundColor: Color {
        if status == .enable {
            switch type {
            case .primary:
                return .white
            case .custom(let textColor, _):
                return textColor
            }
        } else {
            return .white
        }
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            if leading != nil {
                leading
            }
            Text(text)
                .font(.system(size: 16))
                .fontWeight(.medium)
            if trailing != nil {
                trailing
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 32)
        .padding()
        .foregroundColor(foregroundColor)
        .background(backgroundColor)
        .cornerRadius(10)
        .disabled(status == .disable ? true : false)
    }
}

#Preview {
    CustomButton(type: .primary, text: "test", action: {print("hello")}, status: .enable, leading: Image(systemName: "plus.circle.fill"), trailing: Image(systemName: "plus.circle.fill"))
        .padding(.horizontal , 16)
}
