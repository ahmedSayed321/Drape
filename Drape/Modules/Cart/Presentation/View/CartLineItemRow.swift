//
//  CartLineItemRow.swift
//  Drape
//
//  Created by Moaz on 04/07/2026.
//
import SwiftUI
struct CartLineItemRow: View {
    let item: CartLineItemUI
    let onIncrement: () -> Void
    let onDecrement: () -> Void
    let onDelete: () -> Void
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            productImage
            VStack(alignment: .leading, spacing: 8) {
                topRow
                sizeLabel
                Spacer(minLength: 4)
                bottomRow
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
    private var productImage: some View {
        AsyncImage(url: item.imageURL) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                Color(.systemGray6)
            case .empty:
                Color(.systemGray6)
                    .overlay(ProgressView())
            @unknown default:
                Color(.systemGray6)
            }
        }
        .frame(width: 90, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    private var topRow: some View {
        HStack(alignment: .top) {
            Text(item.title)
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.primary)
            Spacer()
            Button(action: onDelete) {
                Image(systemName: "trash.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 16))
            }
        }
    }
    private var sizeLabel: some View {
        Text("Size \(item.size)")
            .font(.system(size: 15))
            .foregroundStyle(.secondary)
    }
    private var bottomRow: some View {
        HStack {
            Text(formattedPrice)
                .font(.system(size: 18, weight: .bold))
            Spacer()
            quantityStepper
        }
    }
    private var quantityStepper: some View {
        HStack(spacing: 10) {
            stepperButton(systemName: "minus", action: onDecrement)
            Text("\(item.quantity)")
                .font(.system(size: 16, weight: .medium))
                .frame(minWidth: 16)
            stepperButton(systemName: "plus", action: onIncrement)
        }
    }
    private func stepperButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.black)
                .frame(width: 28, height: 28)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.black
                                , lineWidth: 1.5)
                )
        }
    }
    private var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        let priceString = formatter.string(from: item.priceDecimal as NSDecimalNumber) ?? "\(item.priceDecimal)"
        return "$ \(priceString)"
    }
}
#Preview {
    CartLineItemRow(
        item: CartLineItemUI(
            id: "1",
            lineItemId: 12,
            title: "Regular Fit Black",
            size: "L",
            imageURL: nil,
            priceDecimal: 1290,
            quantity: 1
        ),
        onIncrement: {},
        onDecrement: {},
        onDelete: {}
    )
    .padding()
}
