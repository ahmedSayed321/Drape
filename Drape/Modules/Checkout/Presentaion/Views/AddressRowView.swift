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
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "location")
                    .foregroundStyle(.gray)
                    .padding(.top, 4)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text(address.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.black)

                        if address.isDefault {
                            Text("Default")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.12))
                                .cornerRadius(8)
                        }
                    }

                    Text(address.details)
                        .font(.system(size: 13))
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                    .foregroundStyle(isSelected ? .black : .gray.opacity(0.6))
                    .padding(.top, 4)
            }
            .padding(16)
            .background(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.25))
            }
        }
    }
}
