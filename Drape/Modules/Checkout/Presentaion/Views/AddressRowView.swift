//
//  AddressRowView.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI

struct AddressRowView: View {
    let address: AddressItem
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(address.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)

                    Text(address.details)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(2)

                    if address.isDefault {
                        Text("Default")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.green)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.12))
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(isSelected ? .black : .gray.opacity(0.5), lineWidth: 1.5)
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(.black)
                            .frame(width: 10, height: 10)
                    }
                }
            }
            .padding(.horizontal, 14)
            .frame(height: 80)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25))
            }
        }
        .buttonStyle(.plain)
    }
}
