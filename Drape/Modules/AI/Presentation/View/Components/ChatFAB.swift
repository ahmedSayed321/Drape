//
//  ChatFAB.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import SwiftUI

struct ChatFAB: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "message.fill")
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.black)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
        }
    }
}
