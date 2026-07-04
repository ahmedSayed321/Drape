//
//  MyCustomAppBar.swift
//  Drape
//
//  Created by TaqieAllah on 04/07/2026.
//

import SwiftUI


struct StandardAppBar: View {
    let title: String
    var showsBackButton: Bool = true
    var trailingSystemImage: String? = nil
    var onBackTapped: () -> Void = {}
    var onTrailingTapped: () -> Void = {}

    var body: some View {
        CustomAppBar(
            title: title,
            leading: {
                if showsBackButton {
                    AppBarIconButton(systemImage: "chevron.left", action: onBackTapped)
                } else {
                    Color.clear
                }
            },
            trailing: {
                if let trailingSystemImage {
                    AppBarIconButton(systemImage: trailingSystemImage, action: onTrailingTapped)
                } else {
                    Color.clear
                }
            }
        )
    }
}

struct CustomAppBar<Leading: View, Trailing: View>: View {
    let title: String
    let showBottomDivider: Bool
    let leading: Leading
    let trailing: Trailing

    init(
        title: String,
        showBottomDivider: Bool = true,
        @ViewBuilder leading: () -> Leading,
        @ViewBuilder trailing: () -> Trailing
    ) {
        self.title = title
        self.showBottomDivider = showBottomDivider
        self.leading = leading()
        self.trailing = trailing()
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                leading
                    .frame(width: 24, height: 24)

                Spacer()

                Text(title)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.black)
                    .lineLimit(1)

                Spacer()

                trailing
                    .frame(minWidth: 24, minHeight: 24)
            }
            .padding(.horizontal, 20)
            .frame(height: 56)

            if showBottomDivider {
                Divider()
                    .padding(.horizontal, 20)
            }
        }
        .background(.white)
    }
}

struct AppBarIconButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(.black)
                .frame(width: 24, height: 24)
        }
    }
}
