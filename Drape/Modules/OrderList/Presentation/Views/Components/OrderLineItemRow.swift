//
//  OrderLineItemRow.swift
//  Drape
//
//  Created by Youssef Abd El-Fatah on 06/07/2026.
//

import SwiftUI
import Kingfisher

struct OrderLineItemRow: View {
    let item: OrderLineItemUIState
    var showReviewButton: Bool = false
    var onLeaveReviewTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            imageView

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)

                if let sizeText = item.sizeText {
                    Text(sizeText)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Text(item.priceText)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black)
            }

            Spacer()

            if showReviewButton {
                Button(action: onLeaveReviewTap) {
                    Text("Leave a Review")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private var imageView: some View {
        KFImage(item.imageURL.flatMap(URL.init))
            .placeholder {
                ProgressView()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 56, height: 56)
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
