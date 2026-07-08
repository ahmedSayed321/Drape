//
//  ProductDetailsScreen.swift
//  Drape
//
//  Created by Me3bed on 03/07/2026.
//

import SwiftUI

public struct ProductDetailsScreen: View {
    @State private var viewModel: ProductDetailsViewModel
    public var productId: Int
    
    private var sizes = ["M","S","L"]
    @State private var selectedSize: String? = "M"
    
    private var keyChain = KeychainTokenStorage()
    public init(productId: Int, viewModel: ProductDetailsViewModel) {
        self.productId = productId
        self._viewModel = State(initialValue: viewModel)
    }
    
    public var body: some View {
        VStack {
            switch viewModel.state {
            case .idle, .loading:
                Spacer()
                ProgressView()
                Text("Loading...")
                Spacer()

            case .failure(let message):
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    Text(message)
                        .multilineTextAlignment(.center)
                }
                Spacer()

            case .success(let product):
                ScrollView {
                    VStack(alignment: .leading) {
                        productImageGallery(
                            imageURLs: product.imageURLs, // see part 2
                            isFavorite: Binding(
                                get: { viewModel.isFavorite },
                                set: { _ in viewModel.toggleFavorite(product: product) }
                            )
                        )

                        titleAndRatingSection(
                            title: product.title,
                            rating: 4.0,
                            reviewCount: 29
                        )
                        .padding(.bottom, 10)

                        descriptionSection(text: product.description)
                            .padding(.bottom, 10)

                        sizeSelectionSection(
                            sizes: product.sizes,
                            selectedSize: $selectedSize
                        )
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }

                Spacer()

                bottomBarSection(
                       price: product.price,
                       isAddingToCart: viewModel.isAddingToCart,
                       onAddToCart: {
                           Task {
                               guard let customerId = keyChain.getShopifyCustomerID() else {
                                   return
                               }
                               let varID = String(product.variantId)
                              
                               await viewModel.addToCart(
                                   variantId: varID,
                                   customerId: customerId,
                                   quantity: 1
                               )
                           }
                       }
                   )
                   .padding(.horizontal, 20)
                   .alert(
                       "Added to Cart",
                       isPresented: $viewModel.showAddToCartSuccessAlert
                   ) {
                       Button("OK", role: .cancel) {}
                   } message: {
                       Text("\(product.title) was added successfully to your cart.")
                   }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Product Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.fetchProductDetails(productId: productId)
            
        }
    }
     
}

func productImageSection(
    imageURL: String?,
    isFavorite: Binding<Bool>
) -> some View {

    ZStack(alignment: .topTrailing) {

        Group {

            if let imageURL,
               let url = URL(string: imageURL) {

                AsyncImage(url: url) { phase in

                    switch phase {

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)

                    case .failure(_):
                        Rectangle()
                            .fill(Color(.systemGray5))

                    case .empty:
                        ProgressView()

                    @unknown default:
                        EmptyView()
                    }

                }

            } else {

                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
            }
        }
        .frame(height: 350)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .clipped()

        Button {
            isFavorite.wrappedValue.toggle()
        } label: {
            Image(systemName: isFavorite.wrappedValue ? "heart.fill" : "heart")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .padding(16)
    }
    .padding(.bottom, 12)
}

extension ProductDetailsScreen {
    func titleAndRatingSection(
        title: String? = nil,
        rating: Double? = nil,
        reviewCount: Int? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title ?? "")
                .font(.system(size: 24))
                .fontWeight(.bold)
                
            HStack(spacing: 4) {
                 Image(systemName: "star.fill")
                     .foregroundColor(.orange)
                     .font(.system(size: 14))

                 if let rating = rating {
                     Text("\(String(format: "%.1f", rating))/5")
                         .font(.subheadline)
                         .fontWeight(.semibold)
                 }

                 if let reviewCount = reviewCount {
                     Text("(\(reviewCount) reviews)")
                         .font(.subheadline)
                         .foregroundColor(.gray)
                         .underline()
                 }
             }
                
            }
        
    }
}


extension ProductDetailsScreen {
    func descriptionSection(text: String? = nil) -> some View {
        Text(text ?? "")
            .font(.subheadline)
            .foregroundColor(.gray)
            .lineSpacing(4)
    }
}

extension ProductDetailsScreen {
    func sizeSelectionSection(
        sizes: [String]? = nil,
        selectedSize: Binding<String?>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose size")
                .font(.system(size: 20))
                .fontWeight(.bold)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sizes ?? [], id: \.self) { size in
                        Button(action: {
                            selectedSize.wrappedValue = size
                        }) {
                            Text(size)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedSize.wrappedValue == size ? .white : .black)
                                .frame(width: 48, height: 48)
                                .background(
                                    selectedSize.wrappedValue == size ? Color.black : Color(.systemGray6)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}


extension ProductDetailsScreen {
    func bottomBarSection(
        price: Double? = nil,
        isAddingToCart: Bool = false,
        onAddToCart: (() -> Void)? = nil
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Price")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)
                    .bold()

                if let price = price {
                    Text("$ \(String(format: "%.0f", price))")
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            .padding(.trailing, 20)

            Spacer()

            CustomButton(
                type: .primary,
                text: isAddingToCart ? "Adding..." : "Add to Cart",
                action: { onAddToCart?() },
                status: isAddingToCart ? .disable : .enable,
                leading: Image(systemName: "cart.fill")
            )
        }
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

func productImageGallery(
    imageURLs: [String]?,
    isFavorite: Binding<Bool>
) -> some View {

    ZStack(alignment: .topTrailing) {

        Group {
            if let urls = imageURLs, !urls.isEmpty {

                TabView {
                    ForEach(urls, id: \.self) { urlString in
                        if let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)

                                case .failure(_):
                                    Rectangle()
                                        .fill(Color(.systemGray5))
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.system(size: 40))
                                                .foregroundColor(.gray)
                                        )

                                case .empty:
                                    ProgressView()

                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 350)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .clipped()
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .frame(height: 350)
                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            } else {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
                    .frame(height: 350)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }

        Button {
            isFavorite.wrappedValue.toggle()
        } label: {
            Image(systemName: isFavorite.wrappedValue ? "heart.fill" : "heart")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.red)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 4)
        }
        .padding(16)
    }
    .padding(.bottom, 12)
}
//#Preview {
//    ProductDetailsScreen(productId: 8419989422266)
//}
#Preview {
    ProductDetailsModuleFactory.makeProductDetailsView(productId: 8419989422266)
}
