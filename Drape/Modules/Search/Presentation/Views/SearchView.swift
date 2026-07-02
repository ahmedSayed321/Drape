//
//  SearchView.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SearchViewModel()
    var onBellTap: () -> Void = {}
    
    var body: some View {
            VStack {
                CustomSearchField(
                    text: $viewModel.searchText,
                    onTextChanged: {viewModel.onSearchTextChanged($0)}
                )
                    .padding(.vertical, 19)
                
                switch viewModel.state {
                    case .recentResults:
                    RecentSearchSectionView(recentSearches: viewModel.recentSearches, onClearAll: {
                        viewModel.clearAllRecentSearches()
                    },onDelete: { query in
                        viewModel.removeRecentSearch(query)
                    })
                    case .loading:
                        Spacer()
                        ProgressView()
                        Spacer()
                    case .success(let products):
                    SearchListView(results: products) {
                        viewModel.saveInRecentSearches()
                    }
                    case .noResult:
                        Spacer()
                        NoResultsFoundStateView()
                        Spacer()
                    }
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onBellTap){
                        Image(systemName: "bell")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }
                
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
                    Text("Search")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
        }
}


#Preview {
    SearchView()
}
