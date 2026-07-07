//
//  FaqRow.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//

import SwiftUI

struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack(alignment: .top) {
                    Text(item.question)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(hex: "1A1A1A"))
                        .multilineTextAlignment(.leading)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "1A1A1A"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .padding(.top, 2)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(item.answer)
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "8A8A8A"))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "E0E0E0"), lineWidth: 1)
        )
    }
}

#Preview {
    FAQRow(item: FAQItem(question: "", answer: "", category: .general), isExpanded: true) {
        
    }
}
