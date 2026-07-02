//
//  HeaderHomeScreenView.swift
//  Drape
//
//  Created by Moaz on 29/06/2026.
//

import SwiftUI

struct HeaderHomeScreenView: View {
    var onBellTap: () -> Void
    var body: some View {
        HStack {
            Text("Discover")
                .font(.system(size: 32, weight: .bold))

            Spacer()

            Button(action: onBellTap){
                Image(systemName: "bell")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    HeaderHomeScreenView(onBellTap: {})
}
