//
//  SliderFilterView.swift
//  Drape
//
//  Created by Moaz on 30/06/2026.
//

import SwiftUI

struct SliderFilterView : View {
    var onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "slider.vertical.3")
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 52, height: 52)
                .background {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(.black)
                }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SliderFilterView(onTap: {})
}
