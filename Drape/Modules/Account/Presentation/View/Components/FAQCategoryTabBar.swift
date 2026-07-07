//
//  FAQCategoryTabBar.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//

import SwiftUI

struct FAQCategoryTabBar: View {
    @Binding var selected: FAQCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FAQCategory.allCases) { category in
                    CategoryChipView(title: category.rawValue, isSelected: selected == category) {
                        selected = category
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

