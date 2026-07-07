//
//  LogoutConfirmationView.swift
//  Drape
//
//  Created by Moaz on 06/07/2026.
//
import SwiftUI

struct LogoutConfirmationView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 48, weight: .regular))
                .foregroundStyle(Color(hex: "ED1010"))
                .padding(.top, 8)

            VStack(spacing: 8) {
                Text("Logout?")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(Color(hex: "1A1A1A"))

                Text("Are you sure you want to logout?")
                    .font(.system(size: 14))
                    .foregroundStyle(Color(hex: "8A8A8A"))
            }

            VStack(spacing: 12) {
                Button(action: onConfirm) {
                    Text("Yes, Logout")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(hex: "ED1010"))
                        )
                }

                Button(action: onCancel) {
                    Text("No, Cancel")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(hex: "1A1A1A"))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "E0E0E0"), lineWidth: 1)
                        )
                }
            }
            .padding(.top, 4)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
        )
        .padding(.horizontal, 24)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.4).ignoresSafeArea()
        LogoutConfirmationView(onConfirm: {}, onCancel: {})
    }
}
