//
//  VendorItemView.swift
//  Drape
//
//  Created by Moaz on 30/06/2026.
//
import SwiftUI

struct BrandItemView: View {
    let brand: Brand
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action:onTap) {
            VStack(spacing: 8) {
                Group {
                    if let imageUrl = brand.imageUrl, let url = URL(string: imageUrl){
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                            case .failure:
                                Image(systemName: "photo")
                                    .foregroundStyle(.gray.opacity(0.6))
                            default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .foregroundStyle(.gray.opacity(0.6))
                    }
                }
                .frame(width: 40, height: 40)
                .frame(width: 86, height: 86)
                .background {
                    RoundedRectangle(cornerRadius: 16.0)
                        .fill(Color(hex: "F8FAFC"))
                }
                
                Text(brand.name)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
}
