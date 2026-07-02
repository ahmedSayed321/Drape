//
//  RangeSliderView.swift
//  Drape
//
//  Created by Moaz on 02/07/2026.
//

import SwiftUI

struct RangeSliderView: View {
    @Binding var lowValue: Double
    @Binding var highValue: Double
    let bounds: ClosedRange<Double>

    private let trackHeight: CGFloat = 4
    private let thumbSize: CGFloat = 22

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let range = bounds.upperBound - bounds.lowerBound
            let lowX = CGFloat((lowValue - bounds.lowerBound) / range) * width
            let highX = CGFloat((highValue - bounds.lowerBound) / range) * width

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color(hex: "E5E5E5"))
                    .frame(height: trackHeight)

                Capsule()
                    .fill(Color.black)
                    .frame(width: max(0, highX - lowX), height: trackHeight)
                    .offset(x: lowX)

                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
                    .offset(x: lowX - thumbSize / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = min(max(0, value.location.x), highX)
                                let newValue = bounds.lowerBound + Double(newX / width) * range
                                lowValue = min(newValue, highValue)
                            }
                    )

                Circle()
                    .fill(Color.white)
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
                    .offset(x: highX - thumbSize / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let newX = max(min(width, value.location.x), lowX)
                                let newValue = bounds.lowerBound + Double(newX / width) * range
                                highValue = max(newValue, lowValue)
                            }
                    )
            }
        }
        .frame(height: thumbSize)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var low: Double = 0
        @State private var high: Double = 19

        var body: some View {
            RangeSliderView(
                lowValue: $low,
                highValue: $high,
                bounds: 0...200
            )
            .padding()
        }
    }
    return PreviewWrapper()
}
