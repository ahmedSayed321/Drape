//
//  FaqsView.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import SwiftUI

struct FaqsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FAQViewModel()

    var body: some View {
        VStack(spacing: 0) {
            FAQCategoryTabBar(
                selected: Binding(
                    get: { viewModel.selectedCategory },
                    set: { viewModel.selectCategory($0) }
                )
            )
            .padding(.top,22)
            .padding(.bottom,18)

            CustomSearchField(
                text: $viewModel.searchText,
                onTextChanged: { viewModel.updateSearch($0) }
            )
            .padding(.horizontal, 20)
            .padding(.bottom, 8)

            GeometryReader { geometry in
                ScrollView {
                    if viewModel.filteredItems.isEmpty {
                        NoResultsFoundStateView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(viewModel.filteredItems) { item in
                                FAQRow(
                                    item: item,
                                    isExpanded: viewModel.isExpanded(item),
                                    onTap: {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            viewModel.toggleExpansion(for: item)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("FAQs")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    FaqsView()
}
