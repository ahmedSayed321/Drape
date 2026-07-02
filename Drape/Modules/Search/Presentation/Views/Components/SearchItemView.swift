//
//  SearchItem.swift
//  Drape
//
//  Created by Moaz on 01/07/2026.
//

import SwiftUI

struct SearchItemView: View {
    let title: String
    let price: String
    let discount: String?
    let imageURL: String
    var onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.gray.opacity(0.6))
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(hex: "F8FAFC"))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.black)

                HStack(spacing: 4) {
                    Text(price)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(hex: "808080"))

                    if let discount {
                        Text(discount)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color(hex: "ED1010"))
                    }
                }
            }

            Spacer()

            Button(action: onTap) {
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.black)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 20)
    }
}

#Preview {
    SearchItemView(
        title: "Regular Fit Polo",
        price: "$ 1,100",
        discount: "-52%",
        imageURL: "https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500",
        onTap: {}
    )
}
