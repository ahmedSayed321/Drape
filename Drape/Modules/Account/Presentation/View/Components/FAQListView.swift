//
//  FAQListView.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//

import SwiftUI

struct FAQListView: View {
    @State private var selectedCategory: FAQCategory = .general
    @State private var expandedID: FAQItem.ID?

    private var filteredItems: [FAQItem] {
        FAQItem.all.filter { $0.category == selectedCategory }
    }

    var body: some View {
        VStack(spacing: 0) {
            FAQCategoryTabBar(selected: $selectedCategory)
                .padding(.vertical, 12)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(filteredItems) { item in
                        FAQRow(
                            item: item,
                            isExpanded: expandedID == item.id,
                            onTap: {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    expandedID = (expandedID == item.id) ? nil : item.id
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
            }
        }
        .onChange(of: selectedCategory) {
            expandedID = nil
        }
    }
}



#Preview {
    FAQListView()
}

