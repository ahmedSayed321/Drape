//
//  HomeScreen.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Fixed Top Header Elements
            VStack {
                HeaderHomeScreenView(onBellTap: {})
                    .padding(.horizontal, 16.0)
                    .padding(.top, 12.0)
                    .padding(.bottom, 16.0)

                HStack(spacing: 8) {
                    CustomSearchField()
                    SliderFilterView(onTap: {})
                }
                .padding(.horizontal, 16.0)
                .padding(.bottom, 16.0)
            }
            
            // MARK: - Dynamic State Layer (Pulled Out of ScrollView)
            if viewModel.isLoading {
                // Now max height expands perfectly to fill the remaining screen space
                VStack {
                    Spacer()
                    ProgressView("Loading")
                    Spacer()
                }
                    
            } else if let errorMessage = viewModel.errorMessage {
                // Pulling this out means Spacers can now push against the entire screen dimensions
                VStack {
                    Spacer()
                    ContentUnavailableView(
                        "Something went wrong",
                        systemImage: "wifi.exclamationmark",
                        description: Text(errorMessage)
                    )
                    Spacer()
                }
                
            } else {
                // MARK: - Content Layer (Only shown when data is ready)
                ScrollView {
                    LazyVStack(pinnedViews: [.sectionHeaders]) { 
                        Section {
                            BrandSectionView(brands: viewModel.brands)
                                .padding(.horizontal, 16.0)
                                .padding(.bottom, 16.0)
                        }
                        
                        Section {
                            HomeProductsGridView(
                                products: viewModel.filteredProducts
                            )
                        } header: {
                            CategoryChipListView(
                                viewModel: viewModel
                            )
                                .padding(.leading, 16.0)
                                .padding(.bottom, 24.0)
                                .background(.white)
                        }
                    }
                    .padding(.horizontal, 16.0)
                }
                .scrollIndicators(.hidden) 
            }
        }
        .task {
            await viewModel.loadHomeData()
        }
    }
}


#Preview {}
