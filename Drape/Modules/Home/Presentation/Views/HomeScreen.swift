//  HomeScreen.swift
//  Drape
//
//  Created by Moaz on 27/06/2026.
//

import SwiftUI

struct HomeScreen: View {
    
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @State private var showFilters = false
    @State private var filterDetent: PresentationDetent = .fraction(0.5)
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView("Loading")
                        Spacer()
                    }

                } else if let errorMessage = viewModel.errorMessage {
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
                    // MARK: - Everything now scrolls together in one ScrollView:
                    // header, search bar, carousel, brands, and product grid.
                    ScrollView {
                        LazyVStack() {

                            // MARK: - Top Header Elements (moved inside ScrollView)
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

                            // MARK: - Featured Products Carousel
                            if !viewModel.featuredProducts.isEmpty {
                                FeaturedProductsCarouselView(products: viewModel.featuredProducts)
                                    .padding(.bottom, 20.0)
                            }

                            Section {
                                BrandSectionView(brands: viewModel.brands)
                                    .padding(.horizontal, 16.0)
                                    .padding(.bottom, 16.0)
                            }

                            Section {
                                HomeProductsGridView(
                                    products: viewModel.filteredProducts
                                )
                                .padding(.horizontal, 16.0)
                            } header: {
                                CategoryChipListView(
                                    viewModel: viewModel
                                )
                                .padding(.leading, 16.0)
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
        }.toolbar(.hidden, for: .navigationBar) 

        }
    }
}


#Preview {
    HomeScreen()
}
