//
//  HomeScreen.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject var viewModel: HomeViewModel
    @State private var showFilters = false
    @State private var filterDetent: PresentationDetent = .fraction(0.5)
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Fixed Top Header Elements
                VStack {
                    HeaderHomeScreenView(onBellTap: {})
                        .padding(.horizontal, 16.0)
                        .padding(.top, 12.0)
                        .padding(.bottom, 16.0)

                    HStack(spacing: 8) {
                        NavigationLink {
                            SearchView()
                        } label: {
                            CustomSearchField(text: .constant(""))
                        }

                        SliderFilterView(onTap: {
                            showFilters.toggle()
                        })
                    }
                    .padding(.horizontal, 16.0)
                    .padding(.bottom, 16.0)
                }
                
                // MARK: - Dynamic State Layer (Pulled Out of ScrollView)
                if viewModel.isLoading {
                    // Now max height expands perfectly to fill the remaining screen space
                    VStack {
                        Spacer()
                        ProgressView()
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
                                    .padding(.bottom, 16.0)
                            }
                            
                            Section {
                                HomeProductsGridView(
                                    products: viewModel.filteredProducts,
                                    onProductAppear: { product in
                                        viewModel.loadMoreProductsIfNeeded(currentItem: product)
                                    },
                                    isFavorited: { viewModel.isFavorited($0) },
                                    onFavoriteTap: { viewModel.toggleFavorite($0) }
                                )
                                .padding(.horizontal, 16.0)
                                if viewModel.isLoadingMore {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                } else if viewModel.selectedCategory != "All" {
                                    HStack(spacing: 6) {
                                        Image(systemName: "line.3.horizontal.decrease.circle")
                                            .foregroundStyle(.secondary)
                                        Text("Clear filters to load more products")
                                            .font(.footnote)
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                }
                            } header: {
                                CategoryChipListView(
                                    viewModel: viewModel
                                )
                                    .padding(.bottom, 24.0)
                                    .background(.white)
                            }
                        }
                    }
                    .scrollIndicators(.hidden) 
                }
            }
            .sheet(isPresented: $showFilters) {
                   FilterSheetView(viewModel: viewModel, selectedDetent: $filterDetent)
                       .presentationDetents([.fraction(0.5), .fraction(0.85)], selection: $filterDetent)
                       .presentationDragIndicator(.visible)
               }
            .task {
                await viewModel.loadHomeData()
        }
        }
    }
}


#Preview {
    HomeEntryPoint()
}
