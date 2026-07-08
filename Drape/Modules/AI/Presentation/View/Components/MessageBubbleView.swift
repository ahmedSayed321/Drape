//
//  MessageBubbleView.swift
//  Drape
//
//  Created by Moaz on 08/07/2026.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage

    var body: some View {
        VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 8) {
            HStack {
                if message.role == .user { Spacer() }
                Text(message.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(message.role == .user ? Color.black : Color(.systemGray5))
                    .foregroundStyle(message.role == .user ? .white : .black)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(maxWidth: 280, alignment: message.role == .user ? .trailing : .leading)
                if message.role == .assistant { Spacer() }
            }

            if let products = message.products, !products.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(products) { product in
                            ChatProductCard(product: product)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: message.role == .user ? .trailing : .leading)
    }
}

struct ChatProductCard: View {
    let product: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AsyncImage(url: URL(string: product.imageUrl ?? "")) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(product.name)
                .font(.caption)
                .lineLimit(2)
            Text(product.price)
                .font(.caption.bold())
        }
        .frame(width: 120)
    }
}
