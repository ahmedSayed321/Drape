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
            Group {
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
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
                                }
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
                await viewModel.loadHomeDataOnce()
            }
            .navigationDestination(for: Brand.self) { brand in   // NEW
                BrandProductsEntryPoint(brand: brand.name)
            }
        }
    }
}


#Preview {
    HomeEntryPoint()
}
