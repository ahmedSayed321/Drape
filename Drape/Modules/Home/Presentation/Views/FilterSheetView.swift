//
//  FilterSheetView.swift
//  Drape
//
//  Created by Moaz on 02/07/2026.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case relevance = "Relevance"
    case priceLowHigh = "Price: Low - High"
    case priceHighLow = "Price: High - Low"
}

struct FilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: HomeViewModel
    @Binding var selectedDetent: PresentationDetent

    @State private var selectedSort: SortOption
    @State private var lowPrice: Double
    @State private var highPrice: Double
    @State private var isSizeExpanded = false
    @State private var selectedSizes: Set<String>
    

    private let priceBounds: ClosedRange<Double>
//    private let sizes = ["XS", "S", "M", "L", "XL", "XXL"]

    init(viewModel: HomeViewModel, selectedDetent: Binding<PresentationDetent>) {
        self.viewModel = viewModel
        self._selectedDetent = selectedDetent
        _selectedSort = State(initialValue: viewModel.sortOption)
        _lowPrice = State(initialValue: viewModel.priceRange.lowerBound)
        _highPrice = State(initialValue: viewModel.priceRange.upperBound)
        _selectedSizes = State(initialValue: viewModel.selectedSizes)
        self.priceBounds = 0...viewModel.maxProductPrice
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Filters")
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.black)
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Sort By")
                        .font(.system(size: 16, weight: .semibold))

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                CategoryChipView(
                                    title: option.rawValue,
                                    isSelected: selectedSort == option,
                                    onTap: { selectedSort = option }
                                )
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Price")
                            .font(.system(size: 16, weight: .semibold))
                        Spacer()
                        Text("$\(Int(lowPrice)) - $\(Int(highPrice))")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }

                    RangeSliderView(lowValue: $lowPrice, highValue: $highPrice, bounds: priceBounds)
                        .padding(.vertical, 8)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        withAnimation {
                            isSizeExpanded.toggle()
                            selectedDetent = isSizeExpanded ? .fraction(0.85) : .fraction(0.5)
                        }
                    }) {
                        HStack {
                            Text("Size")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.gray)
                                .rotationEffect(.degrees(isSizeExpanded ? 180 : 0))
                        }
                    }
                    .buttonStyle(.plain)

                    if isSizeExpanded {
                        let sizes = viewModel.availableSizes
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                            ForEach(sizes, id: \.self) { size in
                                let isSelected = selectedSizes.contains(size)
                                Text(size)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundStyle(isSelected ? .white : .black)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(isSelected ? Color.black : Color(hex: "F1F1F1"))
                                    )
                                    .onTapGesture {
                                        if isSelected {
                                            selectedSizes.remove(size)
                                        } else {
                                            selectedSizes.insert(size)
                                        }
                                    }
                            }
                        }
                    }
                }

                Spacer(minLength: 0)

                Button(action: {
                   viewModel.sortOption = selectedSort
                   viewModel.priceRange = lowPrice...highPrice
                   viewModel.selectedSizes = selectedSizes
                   dismiss()
               }) {
                   Text("Apply Filters")
                       .font(.system(size: 16, weight: .semibold))
                       .foregroundStyle(.white)
                       .frame(maxWidth: .infinity)
                       .padding(.vertical, 16)
                       .background(Color.black)
                       .clipShape(RoundedRectangle(cornerRadius: 14))
               }
           }
           .padding(.horizontal, 20)
           .padding(.top, 20)
       .padding(.bottom, 16)
        }
        .clipped()
   }
}
