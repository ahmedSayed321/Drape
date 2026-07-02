//
//  CategoryChip.swift
//  Drape
//
//  Created by Moaz on 29/06/2026.
//

import SwiftUI

struct CategoryChipView: View {
    var title: String
    var isSelected : Bool
    var onTap: () -> Void

    private var textColor: Color {
            isSelected ? .white : .black
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .medium))
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .frame(height: 36)
            .foregroundStyle(textColor)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? .black : .white)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? .black : .gray.opacity(0.4), lineWidth: 1)
            }
            .animation(.easeInOut(duration: 0.1), value: isSelected)
            .onTapGesture { onTap() }
    }
}

#Preview {
    CategoryChipView(title: "All", isSelected: true, onTap: {})
}
