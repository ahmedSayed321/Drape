//
//  HomeProductCard.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 29/06/2026.
//

import SwiftUI

struct HomeProductCard: View {
    
    let product: Product
    
    @State private var isFavorited: Bool = false
    var onFavTap: () -> Void
    var onCardTap: () -> Void
    
    var body: some View {
        
        ZStack {
            
            // Product details
            VStack(alignment: .leading, spacing: 4) {
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
                        .frame(height: 224)
                        .overlay(
                            Group {
                                if let imageUrl = product.imageUrl, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { phase in
                                        switch phase {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        case .failure(_):
                                            Image(systemName: "photo.fill")
                                                .foregroundColor(.gray.opacity(0.6))
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                } else {
                                    Image(systemName: "photo.fill")
                                        .foregroundColor(.gray.opacity(0.6))
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                Text(product.name)
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .padding(.horizontal, 4)
                    .padding(.top, 4)
                Text(product.price)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            // right top button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isFavorited.toggle()
                        onFavTap()
                        print("fav button clicked")
                    }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(isFavorited ? .red : .black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                    }
                }
                .padding(8)
                Spacer()
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onCardTap()
            print("product card button clicked")
        }
    }
}


#Preview {
}
