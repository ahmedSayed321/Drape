//
//  CategoryChipList.swift
//  Drape
//
//  Created by Moaz on 29/06/2026.
//

import SwiftUI

struct CategoryChipListView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    CategoryChipView(
                        title: category,
                        isSelected: viewModel.selectedCategory == category,
                        onTap: { viewModel.selectedCategory = category }
                    )
                }
            }
            .padding(.leading, 16) // Only leading on first item
            .padding(.trailing, 16) // Only trailing on last item

        }
    }
}

#Preview {
//    let viewModel = HomeViewModel()
//    viewModel.categories = ["All", "Men", "Women", "Kids", "Accessories"]
//    return CategoryChipListView(viewModel: viewModel)
//        .padding()
}
