//
//  FeaturedProductsCarouselView.swift
//  Drape
//

import SwiftUI
import Kingfisher

struct FeaturedProductsCarouselView: View {

    let products: [BannerProduct]

    @State private var selectedIndex = 0
    @Environment(\.openURL) private var openURL

    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                FeaturedProductCard(product: product, isSelected: index == selectedIndex)
                    .tag(index)
                    .padding(.horizontal, 6)
                    .onTapGesture {
                        openLink(product.postLink)
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .frame(height: 220)
        .padding(.leading ,7)
        .padding(.trailing,7)
        .onReceive(timer) { _ in
            // Guard against dividing/mod by zero if products is ever empty
            guard !products.isEmpty else { return }
            withAnimation(.easeInOut(duration: 0.5)) {
                selectedIndex = (selectedIndex + 1) % products.count
            }
        }
    }

    private func openLink(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        openURL(url)
    }
}

private struct FeaturedProductCard: View {

    // Updated to use BannerProduct
    let product: BannerProduct
    let isSelected: Bool

    @State private var didFail = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {

            if didFail {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 32))
                            .foregroundColor(.gray)
                    )
            } else {
                KFImage(URL(string: product.imageURL))
                    .placeholder {
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .overlay(ProgressView())
                    }
                    .onFailure { _ in
                        didFail = true
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .clipped()
        .scaleEffect(isSelected ? 1.0 : 0.94)
        .opacity(isSelected ? 1.0 : 0.7)
        .shadow(color: .black.opacity(isSelected ? 0.15 : 0), radius: 10, y: 6)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isSelected)
    }
}
