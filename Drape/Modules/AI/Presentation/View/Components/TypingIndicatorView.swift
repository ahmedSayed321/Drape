//
//  TypingIndicatorView.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import SwiftUI

struct TypingIndicatorView: View {
    var body: some View {
        HStack {
            ProgressView()
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Spacer()
        }
    }
}
