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

        }
    }
}

#Preview {
}
